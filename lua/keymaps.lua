-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<Leader>tq', function()
  -- Check if quickfix window is already open
  local qf_open = false
  for _, win in pairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_type = vim.bo[buf].buftype
    if buf_type == 'quickfix' then
      qf_open = true
      break
    end
  end

  if qf_open then
    vim.cmd.cclose()
  else
    -- Populate quickfix with diagnostics if empty
    if #vim.fn.getqflist() == 0 then
      vim.diagnostic.setqflist {
        format = function(diagnostic)
          local message = diagnostic.message
          if diagnostic.source then
            message = string.format('[%s] %s', diagnostic.source, message)
          end
          return {
            bufnr = diagnostic.bufnr,
            lnum = diagnostic.lnum + 1,
            col = diagnostic.col + 1,
            text = message,
            type = ({ 'E', 'W', 'I', 'H' })[diagnostic.severity] or 'E',
          }
        end,
      }
    end
    vim.cmd.copen()
    -- Remove these two lines to keep focus on the quickfix window
    -- local current_win = vim.api.nvim_get_current_win()
    -- vim.cmd.wincmd('p') -- Go back to previous window
  end
end, { desc = '[T]oggle [Q]uickfix list' })
-- ...existing code...
-- ...existing code...
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

table.unpack = table.unpack or unpack
local function get_visual()
  local _, ls, cs = table.unpack(vim.fn.getpos 'v')
  local _, le, ce = table.unpack(vim.fn.getpos '.')
  if ls > le or (ls == le and cs > ce) then
    ls, le = le, ls
    cs, ce = ce, cs
  end
  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

vim.keymap.set('v', '<C-r>', function()
  local pattern = table.concat(get_visual())
  pattern = vim.fn.substitute(vim.fn.escape(pattern, '^$.*\\/~[]'), '\n', '\\n', 'g')
  vim.api.nvim_input('<Esc>:%s/' .. pattern .. '//<Left>')
end)

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])
vim.keymap.set('n', '<leader>Y', [["+Y]])
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<leader>k', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>tx', '<cmd>!chmod +x %<CR>', { desc = '[T]oggle the current file executable', silent = true })
vim.keymap.set('n', '<leader>edf', '<cmd>e ~/.config/nvim/<CR>', { desc = '[E]dit [D]ot [F]iles' })
vim.keymap.set('n', ';', ':', { desc = 'CMD enter command mode' })
vim.keymap.set('i', 'jk', '<ESC>')
vim.keymap.set('n', '<leader>ts', vim.lsp.buf.signature_help, { silent = true, noremap = true, desc = '[T]oggle [S]ignature' })
vim.keymap.set('n', '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('wrap: ' .. tostring(vim.wo.wrap))
end, { desc = '[T]oggle [W]rap lines' })

vim.keymap.set('n', '<leader>td', function()
  local cfg = vim.diagnostic.config()
  if cfg.virtual_lines then
    -- Switch back to inline virtual text
    vim.diagnostic.config { virtual_lines = false, virtual_text = {
      source = 'if_many', spacing = 2,
      format = function(d) return d.message end,
    }}
    vim.notify 'diagnostics: inline'
  else
    -- Switch to virtual lines (full-width, below code)
    vim.diagnostic.config { virtual_lines = { current_line = true }, virtual_text = false }
    vim.notify 'diagnostics: full line'
  end
end, { desc = '[T]oggle [D]iagnostic display mode' })
vim.keymap.set('n', ',m', function()
  vim.cmd ':%s/\r//g'
end)
vim.keymap.set('n', '<leader>gb', function()
  require('fzf-lua').git_bcommits()
end, { noremap = true, silent = true, desc = 'Git FZF (B)commits' })
vim.keymap.set('n', '<leader>gs', function()
  require('fzf-lua').git_status()
end, { noremap = true, silent = true, desc = 'Git FZF (S)tatus' })
-- Move selected line(s) down
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv")

-- Move selected line(s) up
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', '<leader>fs', ':w<CR>', { desc = '[F] [S]ave', noremap = true, silent = true })
vim.keymap.set('n', '<leader>fq', ':q<CR>', { desc = '[F] close', noremap = true, silent = true })
vim.keymap.set('n', '<leader>fr', '<cmd>!./%<CR>', { desc = '[F] run', noremap = true, silent = true })

-- Copy number under cursor as hexadecimal
vim.keymap.set('n', '<leader>ch', function()
  -- Get the word under cursor
  local word = vim.fn.expand('<cword>')
  
  -- Try to convert to number
  local num = tonumber(word)
  
  if num then
    -- Convert to hexadecimal (uppercase)
    local hex = string.format('0x%x', num)
    
    -- Copy to clipboard
    vim.fn.setreg('+', hex)
    vim.fn.setreg('"', hex)
    
    vim.notify('Copied: ' .. word .. ' → ' .. hex, vim.log.levels.INFO)
  else
    vim.notify('Not a valid number: ' .. word, vim.log.levels.WARN)
  end
end, { desc = '[C]opy as [H]ex', noremap = true, silent = true })

-- Log trimming shortcuts
-- Trim N bracket groups from all lines in buffer
local function trim_log_brackets_buffer(n)
  -- Save cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  
  -- Get all lines in buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- Process each line
  for i, line in ipairs(lines) do
    -- Only process lines that start with a bracket
    if line:match('^%[') then
      local result = line
      for j = 1, n do
        result = result:gsub('^%[.-%]%s*', '', 1)
      end
      lines[i] = result
    end
    -- Skip lines without brackets (leave them unchanged)
  end
  
  -- Replace all lines in buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  
  -- Restore cursor position
  pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
end

-- <leader>l1: Trim 1 bracket from all lines (show unit + message)
vim.keymap.set('n', '<leader>l1', function()
  trim_log_brackets_buffer(1)
  vim.notify('Trimmed 1 bracket from all lines', vim.log.levels.INFO)
end, { desc = '[L]og trim [1] bracket from buffer (keep unit + message)', noremap = true, silent = true })

-- <leader>l2: Trim 2 brackets from all lines (show only message)
vim.keymap.set('n', '<leader>l2', function()
  trim_log_brackets_buffer(2)
  vim.notify('Trimmed 2 brackets from all lines', vim.log.levels.INFO)
end, { desc = '[L]og trim [2] brackets from buffer (only message)', noremap = true, silent = true })

-- <leader>l3: Trim 3 brackets from all lines
vim.keymap.set('n', '<leader>l3', function()
  trim_log_brackets_buffer(3)
  vim.notify('Trimmed 3 brackets from all lines', vim.log.levels.INFO)
end, { desc = '[L]og trim [3] brackets from buffer', noremap = true, silent = true })

-- vim: ts=2 sts=2 sw=2 et

local function get_ssh_hosts()
  return require('utils').get_ssh_hosts()
end

local function open_clean_remote(host)
  -- 1. Save current shortmess and set it to skip swap dialogs
  local old_shortmess = vim.opt.shortmess:get()
  vim.opt.shortmess:append 'A' -- 'A' ignores "Swap file already exists"

  -- 2. Clean up existing buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name:match '^scp://' then
      vim.cmd('bwipeout! ' .. bufnr)
    end
  end

  -- 3. Open the remote path
  local path = string.format('scp://%s//home/root/', host)

  -- We use pcall (protected call) to catch any remaining 'interrupt' errors
  pcall(function()
    vim.cmd('edit ' .. path)
  end)

  -- 4. Restore your original shortmess settings
  vim.opt.shortmess = old_shortmess
end
-- Retrieve hosts and create bindings
local all_hosts = get_ssh_hosts()

for i = 1, math.min(#all_hosts, 9) do
  local host = all_hosts[i]
  vim.keymap.set('n', '<leader>o' .. i, function()
    open_clean_remote(host)
  end, { desc = 'SSH to ' .. host .. ' and clean sessions' })
end
