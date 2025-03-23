-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local function my_on_attach(bufnr)
      local api = require 'nvim-tree.api'

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', '<C-P>', function()
        api.tree.toggle { file_path = true }
      end, opts 'Toggle nvimtree')
      vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts 'Up')
      vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
    end
    require('nvim-tree').setup {
      on_attach = my_on_attach,
    }
  end,
}
