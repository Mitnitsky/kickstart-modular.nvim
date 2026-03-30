local open_with_trouble = require('trouble.sources.telescope').open

require('telescope').setup {
  defaults = {
    mappings = {
      i = { ['<c-t>'] = open_with_trouble },
      n = { ['<c-t>'] = open_with_trouble },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
    ['fzf'] = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
    hierarchy = {
      initial_multi_expand = false,
      multi_depth = 5,
      layout_strategy = 'horizontal',
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
pcall(require('telescope').load_extension, 'hierarchy')

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sD', function()
  local dir = vim.fn.input { prompt = 'Enter directory: ', default = vim.fn.getcwd(), completion = 'dir' }
  if dir ~= '' then
    builtin.grep_string { search = vim.fn.expand '<cword>', cwd = dir }
    vim.cmd 'echo "" | redraw | echo ""'
  end
end, { desc = '[S]earch current [W]ord in specified directory' })
vim.keymap.set('n', '<leader>sS', builtin.lsp_document_symbols, { desc = '[S]earch current document symbols' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
end, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

-- Hierarchy keymaps
vim.keymap.set('n', '<leader>si', '<cmd>Telescope hierarchy incoming_calls<cr>', { desc = 'LSP: [S]earch [I]ncoming Calls' })
vim.keymap.set('n', '<leader>so', '<cmd>Telescope hierarchy outgoing_calls<cr>', { desc = 'LSP: [S]earch [O]utgoing Calls' })
