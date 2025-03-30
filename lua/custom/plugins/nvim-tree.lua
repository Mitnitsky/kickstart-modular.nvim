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

      -- Safe toggle function that prevents the "lone buffer" problem
      local function safe_toggle()
        local api = require('nvim-tree.api')
        local view = require('nvim-tree.view')
        
        -- If tree is open and it's the only window, create a new buffer before closing
        if view.is_visible() and #vim.api.nvim_list_wins() == 1 then
          vim.cmd('enew') -- Create a new buffer
          vim.cmd('wincmd l') -- Move to the right window
          api.tree.close()
        else
          api.tree.toggle({ file_path = true })
        end
      end
      -- custom mappings
      vim.keymap.set('n', '<leader>te', safe_toggle, { file_path = true,desc = '[T]oggle file [E]xplorer' })
      vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts 'Up')
      vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
      -- vim.keymap.set('n', '<leader>te', api.tree.toggle, { desc = '[T]oggle file [E]xplorer' })
      
      
    end
    require('nvim-tree').setup {
      on_attach = my_on_attach,
    }
  end,
}
