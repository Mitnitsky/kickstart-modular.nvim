-- Build and Upload Plugin for Neovim
-- Provides commands to build and upload binaries with configurable split types

local M = {}

M.config = {
  split_type = 'buffer',
  split_size = 0.3,
  popup_width = 0.8,
  popup_height = 0.6,
  file_open_mode = 'buffer',
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

local function get_cwd()
  return vim.fn.getcwd()
end

local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

local function open_terminal_split(cmd, split_type)
  local win_height = vim.o.lines
  local win_width = vim.o.columns

  if split_type == 'buffer' then
    vim.cmd('terminal ' .. cmd)
  elseif split_type == 'horizontal' then
    local height = math.floor(win_height * M.config.split_size)
    vim.cmd('botright ' .. height .. 'split')
    vim.cmd('terminal ' .. cmd)
  elseif split_type == 'vertical' then
    local width = math.floor(win_width * M.config.split_size)
    vim.cmd('botright ' .. width .. 'vsplit')
    vim.cmd('terminal ' .. cmd)
  elseif split_type == 'popup' then
    local width = math.floor(win_width * M.config.popup_width)
    local height = math.floor(win_height * M.config.popup_height)
    local row = math.floor((win_height - height) / 2)
    local col = math.floor((win_width - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
    })
    vim.fn.termopen(cmd)
  end

  vim.cmd 'startinsert'

  vim.api.nvim_create_autocmd('TermClose', {
    buffer = vim.api.nvim_get_current_buf(),
    callback = function()
      local job_id = vim.b.terminal_job_id
      if job_id then
        vim.schedule(function()
          vim.cmd 'stopinsert'
        end)
      end
    end,
    once = true,
  })
end

local function open_file_with_mode(filepath)
  local mode = M.config.file_open_mode

  if mode == 'split' then
    vim.cmd('split ' .. vim.fn.fnameescape(filepath))
  elseif mode == 'vsplit' then
    vim.cmd('vsplit ' .. vim.fn.fnameescape(filepath))
  elseif mode == 'popup' then
    local win_height = vim.o.lines
    local win_width = vim.o.columns
    local width = math.floor(win_width * M.config.popup_width)
    local height = math.floor(win_height * M.config.popup_height)
    local row = math.floor((win_height - height) / 2)
    local col = math.floor((win_width - width) / 2)

    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
    })
    vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
  else
    vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
  end
end

function M.goto_error()
  local line = vim.api.nvim_get_current_line()
  local filepath, linenum, colnum = line:match '([^%s:]+%.%w+):(%d+):(%d*)'

  if not filepath then
    vim.notify('No file path found on current line', vim.log.levels.WARN)
    return
  end

  local filename = vim.fn.fnamemodify(filepath, ':t')
  local cwd = get_cwd()
  local simple_paths = {
    filepath,
    cwd .. '/' .. filepath,
    cwd .. '/../' .. filepath,
    cwd .. '/../../' .. filepath,
  }

  for _, candidate in ipairs(simple_paths) do
    local normalized = vim.fn.simplify(candidate)
    if file_exists(normalized) then
      vim.cmd 'wincmd p'
      open_file_with_mode(normalized)
      if linenum then
        vim.api.nvim_win_set_cursor(0, { tonumber(linenum), (tonumber(colnum) or 1) - 1 })
        vim.cmd 'normal! zz'
      end
      return
    end
  end

  local has_telescope, telescope_builtin = pcall(require, 'telescope.builtin')

  if has_telescope then
    vim.g._goto_error_line = linenum
    vim.g._goto_error_col = colnum
    vim.g._goto_error_mode = M.config.file_open_mode

    vim.cmd 'wincmd p'

    telescope_builtin.find_files {
      prompt_title = 'Find Error File: ' .. filename,
      default_text = filename,
      attach_mappings = function(prompt_bufnr, map)
        local actions = require 'telescope.actions'
        local action_state = require 'telescope.actions.state'

        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          if selection then
            local fmode = vim.g._goto_error_mode or 'buffer'
            if fmode == 'split' then
              vim.cmd('split ' .. selection.path)
            elseif fmode == 'vsplit' then
              vim.cmd('vsplit ' .. selection.path)
            elseif fmode == 'popup' then
              local win_height = vim.o.lines
              local win_width = vim.o.columns
              local width = math.floor(win_width * M.config.popup_width)
              local height = math.floor(win_height * M.config.popup_height)
              local row = math.floor((win_height - height) / 2)
              local col = math.floor((win_width - width) / 2)

              local buf = vim.api.nvim_create_buf(false, false)
              vim.api.nvim_open_win(buf, true, {
                relative = 'editor',
                width = width,
                height = height,
                row = row,
                col = col,
                style = 'minimal',
                border = 'rounded',
              })
              vim.cmd('edit ' .. selection.path)
            else
              vim.cmd('edit ' .. selection.path)
            end

            if vim.g._goto_error_line then
              vim.api.nvim_win_set_cursor(0, {
                tonumber(vim.g._goto_error_line),
                (tonumber(vim.g._goto_error_col) or 1) - 1,
              })
              vim.cmd 'normal! zz'
              vim.g._goto_error_line = nil
              vim.g._goto_error_col = nil
              vim.g._goto_error_mode = nil
            end
          end
        end)

        return true
      end,
    }
  else
    vim.notify('Could not find file: ' .. filepath .. '\nTelescope not available for fuzzy search', vim.log.levels.ERROR)
  end
end

function M.build()
  local cwd = get_cwd()
  local build_script = cwd .. '/buildAndZip.sh'

  if not file_exists(build_script) then
    vim.notify('No buildAndZip.sh script found in ' .. cwd, vim.log.levels.ERROR)
    return
  end

  local cmd = 'cd ' .. cwd .. ' && source init_dpdk.sh && ./buildAndZip.sh debug pmem_schema_id=1; echo "--- Finished. Press <Enter> to close ---"; read'
  open_terminal_split(cmd, M.config.split_type)
end

local function get_ssh_hosts()
  return require('utils').get_ssh_hosts()
end

function M.upload(ip)
  local cwd = get_cwd()
  local upload_script = cwd .. '/upload_binaries.py'

  if not file_exists(upload_script) then
    vim.notify('Error: upload_binaries.py not found in ' .. cwd, vim.log.levels.ERROR)
    return
  end

  if not ip then
    local hosts = get_ssh_hosts()
    if #hosts == 0 then
      vim.notify('No SSH hosts found in ~/.ssh/config', vim.log.levels.ERROR)
      return
    end

    vim.ui.select(hosts, {
      prompt = 'Select Target Host:',
      format_item = function(item)
        return 'Upload to ' .. item
      end,
    }, function(choice)
      if choice then
        M.upload(choice)
      end
    end)
    return
  end

  local cmd = 'cd ' .. cwd .. ' && python3 upload_binaries.py -f "Lin*" --ips "' .. ip .. '"; echo "Finished. Press <Enter> to close"; read'
  open_terminal_split(cmd, M.config.split_type)
end

-- Initialize with defaults
M.setup {
  split_type = 'buffer',
  split_size = 0.3,
  popup_width = 0.8,
  popup_height = 0.6,
  file_open_mode = 'buffer',
}

-- Commands
vim.api.nvim_create_user_command('Build', function()
  M.build()
end, { desc = 'Build project using buildAndZip.sh' })

vim.api.nvim_create_user_command('Upload', function()
  M.upload()
end, { desc = 'Upload binaries using upload_binaries.py' })

-- Keymaps
vim.keymap.set('n', '<leader>pb', function()
  M.build()
end, { desc = '[B]uild project' })

vim.keymap.set('n', '<leader>pu', function()
  M.upload()
end, { desc = '[U]pload binaries' })

vim.keymap.set({ 'n', 't' }, '<leader>gf', function()
  if vim.fn.mode() == 't' then
    vim.cmd 'stopinsert'
  end
  M.goto_error()
end, { desc = '[G]o to [F]ile from error line' })
