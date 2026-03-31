vim.g.undotree_diff_view_options = [[-p --color-moved=plain]]
vim.g.undotree_split_width = 40
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_auto_refresh = 1
vim.opt.undodir = vim.fn.stdpath 'data' .. '/undodir'
vim.opt.undolevels = 10000
vim.opt.undoreload = 100000

vim.keymap.set('n', '<leader>tu', '<cmd>UndotreeToggle<cr>', { desc = '[T]oggle [u]ndotree' })
