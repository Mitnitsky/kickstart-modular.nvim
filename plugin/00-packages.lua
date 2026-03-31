-- Plugin declarations & hooks for vim.pack (Neovim 0.12)
-- This file is sourced first (00- prefix) to ensure all plugins
-- are installed and loaded before per-plugin setup files run.

-- ── Hooks (must be defined before vim.pack.add) ──────────────
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

-- ── Install & Load ───────────────────────────────────────────
vim.pack.add {
  -- Core libraries
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
  'https://github.com/Mofiqul/vscode.nvim',

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
