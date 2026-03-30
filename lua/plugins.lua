-- Plugin Management for Neovim 0.12+
-- Uses built-in vim.pack instead of lazy.nvim
--
-- Commands:
--   :lua vim.pack.update()              -- Update all plugins
--   :lua vim.pack.update({'mini.nvim'})  -- Update specific plugin
--   :lua vim.pack.del({'plugin-name'})   -- Delete a plugin
--   :checkhealth vim.pack              -- Troubleshoot

-- ============================================================
-- Plugin Hooks (must be defined before the first vim.pack.add)
-- ============================================================
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    local plugin_dir = vim.fn.stdpath 'data' .. '/site/pack/core/opt/' .. name

    if name == 'nvim-treesitter' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      require('nvim-treesitter').update(nil, { summary = true })
    elseif name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
      vim.fn.system { 'make', '-C', plugin_dir }
    elseif name == 'LuaSnip' and vim.fn.executable 'make' == 1 then
      vim.fn.system { 'make', '-C', plugin_dir, 'install_jsregexp' }
    elseif name == 'cargo.nvim' and vim.fn.executable 'cargo' == 1 then
      vim.fn.system { 'cargo', 'build', '--release', '--manifest-path', plugin_dir .. '/Cargo.toml' }
    end
  end,
})

-- ============================================================
-- Install & Load Plugins
-- ============================================================
vim.pack.add {
  -- Core libraries (loaded first — other plugins depend on these)
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',

  -- Treesitter
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },

  -- Snippets & Completion
  'https://github.com/saghen/blink.download',
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.x' },
  'https://github.com/folke/lazydev.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.x' },
  { src = 'https://github.com/saghen/blink.pairs', version = vim.version.range '*' },

  -- Fuzzy Finder
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/jmacadie/telescope-hierarchy.nvim',
  'https://github.com/ibhagwan/fzf-lua',

  -- LSP & Tools
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/stevearc/conform.nvim',

  -- UI & Navigation
  'https://github.com/folke/which-key.nvim',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/nvim-tree/nvim-tree.lua',
  'https://github.com/mbbill/undotree',

  -- Themes
  'https://github.com/xiantang/darcula-dark.nvim',
  'https://github.com/catppuccin/nvim',

  -- Git
  'https://github.com/kdheepak/lazygit.nvim',

  -- AI & Copilot
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/folke/snacks.nvim',
  'https://github.com/folke/sidekick.nvim',

  -- Language Specific
  { src = 'https://github.com/mrcjkb/rustaceanvim', version = vim.version.range '5.x' },
  'https://github.com/nwiizo/cargo.nvim',

  -- Debug
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',

  -- Misc
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/MTDL9/vim-log-highlighting',
  'https://github.com/selimacerbas/live-server.nvim',
  'https://github.com/selimacerbas/markdown-preview.nvim',
}

-- ============================================================
-- Colorscheme (set early, after plugins are loaded)
-- ============================================================
vim.cmd.colorscheme 'darcula-dark'

-- ============================================================
-- Treesitter
-- ============================================================
-- Neovim 0.12 has built-in treesitter highlight/indent support.
-- nvim-treesitter (main branch) is used for parser installation.
require('nvim-treesitter').install { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }

-- ============================================================
-- Completion (blink.cmp)
-- ============================================================
require('blink.cmp').setup {
  keymap = {
    preset = 'enter',
    ['<C-q>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<Tab>'] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      'snippet_forward',
      'fallback',
    },
    ['<CR>'] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      'snippet_forward',
      'fallback',
    },
  },
  appearance = {
    nerd_font_variant = 'mono',
    kind_icons = {
      Copilot = '',
      Text = '󰉿',
      Method = '󰊕',
      Function = '󰊕',
      Constructor = '󰒓',
      Field = '󰜢',
      Variable = '󰆦',
      Property = '󰖷',
      Class = '󱡠',
      Interface = '󱡠',
      Struct = '󱡠',
      Module = '󰅩',
      Unit = '󰪚',
      Value = '󰦨',
      Enum = '󰦨',
      EnumMember = '󰦨',
      Keyword = '󰻾',
      Constant = '󰏿',
      Snippet = '󱄽',
      Color = '󰏘',
      File = '󰈔',
      Reference = '󰬲',
      Folder = '󰉋',
      Event = '󱐋',
      Operator = '󰪚',
      TypeParameter = '󰬛',
    },
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 700 },
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}

-- ============================================================
-- blink.pairs
-- ============================================================
require('blink.pairs').setup {
  mappings = {
    enabled = true,
    cmdline = true,
    disabled_filetypes = {},
    pairs = {},
  },
  highlights = {
    enabled = true,
    cmdline = true,
    groups = { 'BlinkPairsOrange', 'BlinkPairsPurple', 'BlinkPairsBlue' },
    unmatched_group = 'BlinkPairsUnmatched',
    matchparen = {
      enabled = true,
      cmdline = false,
      include_surrounding = false,
      group = 'BlinkPairsMatchParen',
      priority = 250,
    },
  },
  debug = false,
}

-- ============================================================
-- LuaSnip & lazydev
-- ============================================================
require('luasnip').setup {}

require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

-- ============================================================
-- LSP Configuration (Native Neovim 0.12)
-- ============================================================

-- Set global LSP capabilities from blink.cmp
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- LSP attach handler for keymaps and features
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
    map('<leader>T', require('telescope.builtin').lsp_type_definitions, '[T]ype Definition')
    map('<leader>Ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<leader>crn', vim.lsp.buf.rename, '[C]ode [R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Highlight references on CursorHold
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Toggle inlay hints
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Diagnostic Config
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
}

-- Enable LSP servers (configs are in lsp/ directory)
vim.lsp.enable { 'clangd', 'bashls', 'lua_ls', 'ccls' }

-- ============================================================
-- Mason (tool installer — use :Mason to manage)
-- ============================================================
require('mason').setup {}

-- ============================================================
-- Fidget (LSP progress notifications)
-- ============================================================
require('fidget').setup {}

-- ============================================================
-- Telescope
-- ============================================================
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

-- Telescope hierarchy keymaps
vim.keymap.set('n', '<leader>si', '<cmd>Telescope hierarchy incoming_calls<cr>', { desc = 'LSP: [S]earch [I]ncoming Calls' })
vim.keymap.set('n', '<leader>so', '<cmd>Telescope hierarchy outgoing_calls<cr>', { desc = 'LSP: [S]earch [O]utgoing Calls' })

-- ============================================================
-- Conform (formatting)
-- ============================================================
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
  },
}

vim.keymap.set('', '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })

-- ============================================================
-- Which-key
-- ============================================================
require('which-key').setup {
  delay = 0,
  icons = {
    mappings = vim.g.have_nerd_font,
    keys = vim.g.have_nerd_font and {} or {
      Up = '<Up> ',
      Down = '<Down> ',
      Left = '<Left> ',
      Right = '<Right> ',
      C = '<C-…> ',
      M = '<M-…> ',
      D = '<D-…> ',
      S = '<S-…> ',
      CR = '<CR> ',
      Esc = '<Esc> ',
      ScrollWheelDown = '<ScrollWheelDown> ',
      ScrollWheelUp = '<ScrollWheelUp> ',
      NL = '<NL> ',
      BS = '<BS> ',
      Space = '<Space> ',
      Tab = '<Tab> ',
      F1 = '<F1>',
      F2 = '<F2>',
      F3 = '<F3>',
      F4 = '<F4>',
      F5 = '<F5>',
      F6 = '<F6>',
      F7 = '<F7>',
      F8 = '<F8>',
      F9 = '<F9>',
      F10 = '<F10>',
      F11 = '<F11>',
      F12 = '<F12>',
    },
  },
  spec = {
    { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
    { '<leader>D', group = '[D]ocument' },
    { '<leader>r', group = '[R]ename' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  },
}

-- ============================================================
-- Trouble
-- ============================================================
require('trouble').setup {}

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols (Trouble)' })
vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'LSP Definitions / references / ... (Trouble)' })
vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })

-- ============================================================
-- Todo-comments
-- ============================================================
require('todo-comments').setup { signs = false }

-- ============================================================
-- Mini.nvim
-- ============================================================
require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

-- ============================================================
-- Gitsigns
-- ============================================================
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [s]tage hunk' })
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
    map('n', '<leader>hv', gitsigns.preview_hunk, { desc = 'git pre[v]iew hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis '@'
    end, { desc = 'git [D]iff against last commit' })
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
  end,
}

-- ============================================================
-- nvim-tree
-- ============================================================
local function nvim_tree_on_attach(bufnr)
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
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts 'Up')
  vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
end

require('nvim-tree').setup { on_attach = nvim_tree_on_attach }

-- ============================================================
-- Undotree
-- ============================================================
vim.g.undotree_diff_view_options = [[-p --color-moved=plain]]
vim.g.undotree_split_width = 40
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_auto_refresh = 1
vim.opt.undodir = os.getenv 'HOME' .. '/.nvim/undodir'
vim.opt.undolevels = 10000
vim.opt.undoreload = 100000

vim.keymap.set('n', '<leader>tu', '<cmd>UndotreeToggle<cr>', { desc = '[T]oggle [u]ndotree' })

-- ============================================================
-- LazyGit
-- ============================================================
vim.g.lazygit_use_neovim_remote = 0
vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })

-- ============================================================
-- Copilot
-- ============================================================
require('copilot').setup {
  server = {
    type = 'binary',
    custom_server_filepath = 'copilot-language-server',
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = true,
    debounce = 75,
    trigger_on_accept = true,
    keymap = {
      accept = '<M-a>',
      accept_word = false,
      accept_line = false,
      next = '<M-n>',
      prev = '<M-p>',
      dismiss = '<M-d>',
    },
  },
  workspace_folders = {
    '/home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/',
  },
  panel = { enabled = false },
}

-- ============================================================
-- Snacks
-- ============================================================
require('snacks').setup {
  lazygit = {},
  picker = {
    actions = {
      sidekick_send = function(...)
        return require('sidekick.cli.picker.snacks').send(...)
      end,
    },
    win = {
      input = {
        keys = {
          ['<a-a>'] = { 'sidekick_send', mode = { 'n', 'i' } },
        },
      },
    },
  },
}

-- ============================================================
-- Sidekick
-- ============================================================
require('sidekick').setup {
  nes = {
    enabled = function()
      return vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false
    end,
    debounce = 100,
    trigger = { events = { 'ModeChanged i:n', 'TextChanged', 'User SidekickNesDone' } },
    clear = { events = { 'TextChangedI', 'InsertEnter' }, esc = true },
    diff = { inline = 'words', show = 'always' },
    signs = true,
    jumplist = true,
  },
  cli = {
    watch = true,
    win = {
      wo = {},
      bo = {},
      layout = 'right',
      float = { width = 0.9, height = 0.9 },
      split = { width = 80, height = 20 },
      keys = {
        buffers = { '<c-b>', 'buffers', mode = 'nt', desc = 'open buffer picker' },
        files = { '<c-f>', 'files', mode = 'nt', desc = 'open file picker' },
        hide_n = { 'q', 'hide', mode = 'n', desc = 'hide the terminal window' },
        hide_ctrl_q = { '<c-q>', 'hide', mode = 'n', desc = 'hide the terminal window' },
        hide_ctrl_dot = { '<c-.>', 'hide', mode = 'nt', desc = 'hide the terminal window' },
        hide_ctrl_z = { '<c-z>', 'blur', mode = 'nt', desc = 'go back to the previous window' },
        prompt = { '<c-p>', 'prompt', mode = 't', desc = 'insert prompt or context' },
        stopinsert = { '<c-q>', 'stopinsert', mode = 't', desc = 'enter normal mode' },
        nav_left = { '<c-h>', 'nav_left', expr = true, desc = 'navigate to the left window' },
        nav_down = { '<c-j>', 'nav_down', expr = true, desc = 'navigate to the below window' },
        nav_up = { '<c-k>', 'nav_up', expr = true, desc = 'navigate to the above window' },
        nav_right = { '<c-l>', 'nav_right', expr = true, desc = 'navigate to the right window' },
      },
    },
    mux = {
      backend = vim.env.ZELLIJ and 'zellij' or 'tmux',
      enabled = true,
      create = 'terminal',
      split = { vertical = true, size = 0.5 },
    },
    tools = {
      aider = {},
      amazon_q = {},
      claude = {},
      codex = {},
      copilot = {},
      crush = {},
      cursor = {},
      gemini = {},
      grok = {},
      opencode = {},
      pi = {},
      qwen = {},
    },
    context = {},
    prompts = {
      changes = 'Can you review my changes?',
      diagnostics = 'Can you help me fix the diagnostics in {file}?\n{diagnostics}',
      diagnostics_all = 'Can you help me fix these diagnostics?\n{diagnostics_all}',
      document = 'Add documentation to {function|line}',
      explain = 'Explain {this}',
      fix = 'Can you fix {this}?',
      optimize = 'How can {this} be optimized?',
      review = 'Can you review {file} for any issues or improvements?',
      tests = 'Can you write tests for {this}?',
      buffers = '{buffers}',
      file = '{file}',
      line = '{line}',
      position = '{position}',
      quickfix = '{quickfix}',
      selection = '{selection}',
      ['function'] = '{function}',
      class = '{class}',
    },
    picker = 'snacks',
  },
  copilot = {
    status = { enabled = true, level = vim.log.levels.WARN },
  },
  ui = {
    icons = {
      nes = ' ',
      attached = ' ',
      started = ' ',
      installed = ' ',
      missing = ' ',
      external_attached = '󰖩 ',
      external_started = '󰖪 ',
      terminal_attached = ' ',
      terminal_started = ' ',
    },
  },
  debug = false,
}

-- Sidekick keymaps
vim.keymap.set('n', '<tab>', function()
  if not require('sidekick').nes_jump_or_apply() then
    return '<Tab>'
  end
end, { expr = true, desc = 'Goto/Apply Next Edit Suggestion' })
vim.keymap.set({ 'n', 't', 'i', 'x' }, '<c-.>', function()
  require('sidekick.cli').focus()
end, { desc = 'Sidekick Focus' })
vim.keymap.set('n', '<leader>aa', function()
  require('sidekick.cli').toggle()
end, { desc = 'Sidekick Toggle CLI' })
vim.keymap.set('n', '<leader>as', function()
  require('sidekick.cli').select()
end, { desc = 'Select CLI' })
vim.keymap.set('n', '<leader>ad', function()
  require('sidekick.cli').close()
end, { desc = 'Detach a CLI Session' })
vim.keymap.set({ 'x', 'n' }, '<leader>at', function()
  require('sidekick.cli').send { msg = '{this}' }
end, { desc = 'Send This' })
vim.keymap.set('n', '<leader>af', function()
  require('sidekick.cli').send { msg = '{file}' }
end, { desc = 'Send File' })
vim.keymap.set('x', '<leader>av', function()
  require('sidekick.cli').send { msg = '{selection}' }
end, { desc = 'Send Visual Selection' })
vim.keymap.set({ 'n', 'x' }, '<leader>ap', function()
  require('sidekick.cli').prompt()
end, { desc = 'Sidekick Select Prompt' })
vim.keymap.set('n', '<leader>ac', function()
  require('sidekick.cli').toggle { name = 'copilot', focus = true }
end, { desc = 'Sidekick Toggle Copilot CLI' })

-- ============================================================
-- Rustaceanvim
-- ============================================================
vim.g.rustaceanvim = {
  tools = {},
  server = {
    on_attach = function(_, _) end,
    default_settings = {
      ['rust-analyzer'] = {
        cargo = { target = 'aarch64-unknown-linux-gnu' },
        runnables = {
          extraArgs = { '--verbose', '--target', 'aarch64-unknown-linux-gnu' },
          extraEnv = { TARGET_SOC = '10.33.17.10' },
        },
        check = { command = 'cargo clippy -- -D warnings' },
      },
    },
  },
  dap = {},
}

-- ============================================================
-- Cargo.nvim
-- ============================================================
require('cargo').setup {
  float_window = true,
  window_width = 0.8,
  window_height = 0.8,
  border = 'rounded',
  auto_close = false,
  close_timeout = 5000,
}

-- ============================================================
-- DAP (Debug Adapter Protocol)
-- ============================================================
local dap = require 'dap'
local dapui = require 'dapui'

dapui.setup {
  elements = {
    { id = 'scopes', size = 0.25 },
    { id = 'breakpoints', size = 0.25 },
    { id = 'stacks', size = 0.25 },
    { id = 'watches', size = 0.25 },
  },
  size = 40,
  position = 'right',
}

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

dap.adapters.rust_gdb_direct = {
  type = 'executable',
  command = '/home/vmitnitsky/.cargo/bin/rust-gdb',
}

dap.configurations.rust = {
  {
    name = 'Attach Remote GDB (Direct)',
    type = 'rust_gdb_direct',
    request = 'attach',
    program = '/home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/build/RDMA/linux/consumer/rust-consumer/target/aarch64-unknown-linux-gnu/debug/incremental/lifetimes-1jk5g9rp9z30m',
    args = {
      '--interpreter=mi2',
      '-ex', 'set confirm off',
      '-ex', 'set auto-solib-add off',
      '-ex', 'set auto-load safe-path /',
      '-ex', 'file /home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/build/RDMA/linux/consumer/rust-consumer/target/aarch64-unknown-linux-gnu/debug/incremental/lifetimes-1jk5g9rp9z30m',
      '-ex', 'set sysroot /home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/build/RDMA/linux/consumer/rust-consumer/target/aarch64-unknown-linux-gnu/debug/incremental/',
      '-ex', 'target remote 10.33.17.10:10000',
      '-q',
    },
    cwd = vim.fn.getcwd(),
    env = {
      RUST_GDB = '/usr/bin/gdb-multiarch',
    },
  },
}

-- ============================================================
-- Markdown Preview
-- ============================================================
require('markdown_preview').setup {
  port = 8421,
  open_browser = false,
  debounce_ms = 300,
}

-- ============================================================
-- fzf-lua
-- ============================================================
require('fzf-lua').setup {}

-- vim: ts=2 sts=2 sw=2 et
