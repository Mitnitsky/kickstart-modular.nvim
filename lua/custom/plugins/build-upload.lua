-- Build and Upload Plugin for Neovim
-- Provides commands to build and upload binaries with configurable split types

return {
  {
    dir = vim.fn.stdpath 'config',
    name = 'build-upload',
    lazy = false,
    config = function()
      local M = {}

      -- Default configuration
      M.config = {
        -- Split type for build/upload terminal: 'buffer', 'horizontal', 'vertical', or 'popup'
        split_type = 'buffer',
        -- Split size (percentage for horizontal/vertical, or dimensions for popup)
        split_size = 0.3, -- 30% of screen
        popup_width = 0.8, -- 80% of screen width
        popup_height = 0.6, -- 60% of screen height
        -- File opening mode for goto_error: 'buffer', 'split', 'vsplit', or 'popup'
        file_open_mode = 'buffer',
      }

      -- Setup function to allow user configuration
      function M.setup(opts)
        M.config = vim.tbl_deep_extend('force', M.config, opts or {})
      end

      -- Helper function to get current working directory
      local function get_cwd()
        return vim.fn.getcwd()
      end

      -- Helper function to check if file exists
      local function file_exists(path)
        return vim.fn.filereadable(path) == 1
      end

      -- Helper function to create a terminal in a split
      local function open_terminal_split(cmd, split_type)
        local win_height = vim.o.lines
        local win_width = vim.o.columns

        if split_type == 'buffer' then
          -- Open terminal in current buffer
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
          -- Create a floating window
          local width = math.floor(win_width * M.config.popup_width)
          local height = math.floor(win_height * M.config.popup_height)
          local row = math.floor((win_height - height) / 2)
          local col = math.floor((win_width - width) / 2)

          local buf = vim.api.nvim_create_buf(false, true)
          local win = vim.api.nvim_open_win(buf, true, {
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

        -- Enter insert mode automatically
        vim.cmd 'startinsert'

        -- Set up autocmd to exit insert mode on BuildExit/UploadExit events
        vim.api.nvim_create_autocmd('TermClose', {
          buffer = vim.api.nvim_get_current_buf(),
          callback = function()
            -- Check exit code - if non-zero, switch to normal mode
            local job_id = vim.b.terminal_job_id
            if job_id then
              vim.schedule(function()
                -- Exit insert mode after terminal closes
                vim.cmd 'stopinsert'
              end)
            end
          end,
          once = true,
        })
      end

      -- Helper function to open file based on config mode
      local function open_file_with_mode(filepath)
        local mode = M.config.file_open_mode

        if mode == 'split' then
          vim.cmd('split ' .. vim.fn.fnameescape(filepath))
        elseif mode == 'vsplit' then
          vim.cmd('vsplit ' .. vim.fn.fnameescape(filepath))
        elseif mode == 'popup' then
          -- Create a floating window for the file
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
          -- Default 'buffer' mode - open in current window
          vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
        end
      end

      -- Function to navigate to file:line under cursor using Telescope
      function M.goto_error()
        local line = vim.api.nvim_get_current_line()

        -- Match common error patterns:
        -- ../path/to/file.h:188:1:
        -- path/file.c:42:5: error:
        local filepath, linenum, colnum = line:match '([^%s:]+%.%w+):(%d+):(%d*)'

        if not filepath then
          vim.notify('No file path found on current line', vim.log.levels.WARN)
          return
        end

        -- Extract just the filename from the path
        local filename = vim.fn.fnamemodify(filepath, ':t')

        -- First try simple path resolution
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
            -- Close terminal window and open the file
            vim.cmd 'wincmd p' -- Go back to previous window
            open_file_with_mode(normalized)

            -- Jump to line number
            if linenum then
              vim.api.nvim_win_set_cursor(0, { tonumber(linenum), (tonumber(colnum) or 1) - 1 })
              vim.cmd 'normal! zz' -- Center the line
            end
            return
          end
        end

        -- If simple resolution failed, use Telescope to find the file
        local has_telescope, telescope_builtin = pcall(require, 'telescope.builtin')

        if has_telescope then
          -- Store the line and column info for after file is found
          vim.g._goto_error_line = linenum
          vim.g._goto_error_col = colnum
          vim.g._goto_error_mode = M.config.file_open_mode

          -- Close terminal window first
          vim.cmd 'wincmd p'

          -- Use Telescope to find the file
          telescope_builtin.find_files {
            prompt_title = 'Find Error File: ' .. filename,
            default_text = filename,
            attach_mappings = function(prompt_bufnr, map)
              local actions = require 'telescope.actions'
              local action_state = require 'telescope.actions.state'

              -- Override the default select action
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()

                if selection then
                  -- Use the configured file open mode
                  local mode = vim.g._goto_error_mode or 'buffer'
                  if mode == 'split' then
                    vim.cmd('split ' .. selection.path)
                  elseif mode == 'vsplit' then
                    vim.cmd('vsplit ' .. selection.path)
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
                    vim.cmd('edit ' .. selection.path)
                  else
                    vim.cmd('edit ' .. selection.path)
                  end

                  -- Jump to the stored line number
                  if vim.g._goto_error_line then
                    vim.api.nvim_win_set_cursor(0, {
                      tonumber(vim.g._goto_error_line),
                      (tonumber(vim.g._goto_error_col) or 1) - 1,
                    })
                    vim.cmd 'normal! zz'

                    -- Clear the stored values
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

      -- Build function
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

      -- Helper function to get SSH hosts from ~/.ssh/config
      local function get_ssh_hosts()
        local hosts = {}
        local ssh_config = vim.fn.expand '~/.ssh/config'

        if vim.fn.filereadable(ssh_config) == 0 then
          return hosts
        end

        for line in io.lines(ssh_config) do
          -- Match lines starting with 'Host' but ignore wildcards like '*'
          local host = line:match '^Host%s+(%S+)'
          if host and host ~= '*' then
            table.insert(hosts, host)
          end
        end
        return hosts
      end

      -- Upload function with IP selection from SSH config
      function M.upload(ip)
        local cwd = get_cwd()
        local upload_script = cwd .. '/upload_binaries.py'

        if not file_exists(upload_script) then
          vim.notify('Error: upload_binaries.py not found in ' .. cwd, vim.log.levels.ERROR)
          return
        end

        -- If IP is not provided, show selection menu from SSH config
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

      -- You can customize the default split type here
      M.setup {
        split_type = 'buffer', -- Terminal split for build/upload: 'buffer', 'horizontal', 'vertical', or 'popup'
        split_size = 0.3, -- 30% of screen for horizontal/vertical splits
        popup_width = 0.8, -- 80% for popup
        popup_height = 0.6, -- 60% for popup
        file_open_mode = 'buffer', -- File opening for goto_error: 'buffer', 'split', 'vsplit', or 'popup'
      }

      -- Setup commands
      vim.api.nvim_create_user_command('Build', function()
        M.build()
      end, {
        desc = 'Build project using buildAndZip.sh',
      })

      vim.api.nvim_create_user_command('Upload', function()
        M.upload()
      end, {
        desc = 'Upload binaries using upload_binaries.py',
      })

      -- Setup keymaps (using leader b and leader u similar to tmux)
      vim.keymap.set('n', '<leader>pb', function()
        M.build()
      end, { desc = '[B]uild project' })

      vim.keymap.set('n', '<leader>pu', function()
        M.upload()
      end, { desc = '[U]pload binaries' })

      -- Keybind to navigate to error from terminal window
      -- Works in both normal and terminal mode
      vim.keymap.set({ 'n', 't' }, '<leader>gf', function()
        -- If in terminal mode, exit to normal mode first
        if vim.fn.mode() == 't' then
          vim.cmd 'stopinsert'
        end
        M.goto_error()
      end, { desc = '[G]o to [F]ile from error line' })
    end,
  },
}
