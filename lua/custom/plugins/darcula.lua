return {
  'xiantang/darcula-dark.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  name = 'darcula-dark',
  priority = 1000,
  init = function()
    vim.cmd.colorscheme 'darcula-dark'
  end,
}
