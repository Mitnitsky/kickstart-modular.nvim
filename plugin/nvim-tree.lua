local function on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  local function safe_toggle()
    local tree_api = require 'nvim-tree.api'
    local view = require 'nvim-tree.view'
    if view.is_visible() and #vim.api.nvim_list_wins() == 1 then
      vim.cmd 'enew'
      vim.cmd 'wincmd l'
      tree_api.tree.close()
    else
      tree_api.tree.toggle { file_path = true }
    end
  end

  vim.keymap.set('n', '<leader>te', safe_toggle, { desc = '[T]oggle file [E]xplorer' })
  vim.keymap.set('n', '<leader>tf', function()
    require('nvim-tree.api').tree.find_file { open = true, focus = true }
  end, { desc = '[T]oggle [F]ind file in tree' })
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts 'Up')
  vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
end

require('nvim-tree').setup {
  on_attach = on_attach,
  view = {
    width = 40,
  },
}
