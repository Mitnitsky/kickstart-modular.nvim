  -- Neovim 0.12+ Configuration

-- Enable Lua module cache for faster startup
vim.loader.enable()

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- Plugins are loaded automatically from the plugin/ directory.
-- Each file in plugin/ is sourced alphabetically at startup.
--   plugin/00-packages.lua  — vim.pack.add() declarations + hooks
--   plugin/<name>.lua       — per-plugin setup & keymaps
--
-- Commands:
--   :lua vim.pack.update()   — update all plugins
--   :checkhealth vim.pack   — troubleshoot

-- vim: ts=2 sts=2 sw=2 et
