-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
-- ...existing code...
-- ...existing code...
vim.keymap.set('n', '<Leader>tq', function()
  -- Check if quickfix window is already open
  local qf_open = false
  for _, win in pairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype')
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

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('x', '<leader>p', [["_dP]])
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])
vim.keymap.set('n', '<leader>Y', [["+Y]])
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<leader>k', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>cprev<CR>zz')
-- vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
-- vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')
vim.keymap.set('n', '<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { desc = 'Make the current file executable', silent = true })
vim.keymap.set('n', '<leader>edf', '<cmd>e ~/.config/nvim/<CR>')
vim.keymap.set('n', ';', ':', { desc = 'CMD enter command mode' })
vim.keymap.set('i', 'jk', '<ESC>')
vim.keymap.set({ 'n' }, '<leader>ts', function()
  require('lsp_signature').toggle_float_win()
end, { silent = true, noremap = true, desc = '[T]oggle [S]ignature' })
vim.keymap.set('n', ',m', function()
  vim.cmd ':%s/\r//g'
end)
vim.keymap.set('n', '<leader>fs', ':w<CR>', { desc = '[F] [S]ave', noremap = true, silent = true })
vim.keymap.set('n', '<leader>fq', ':q<CR>', { desc = '[F] close', noremap = true, silent = true })
-- vim: ts=2 sts=2 sw=2 et
