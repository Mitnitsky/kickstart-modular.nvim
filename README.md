# kickstart-modular.nvim

## Introduction

*This is a fork of [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) that moves from a single file to a multi file configuration.*

A starting point for Neovim that is:

* Small
* Modular
* Completely Documented

**NOT** a Neovim distribution, but instead a starting point for your configuration.

## Quick Reference

**Essential Prerequisites:**
- Neovim >= 0.10 (stable or nightly)
- `git`, `make`, `unzip`, C Compiler (`gcc` or `clang`)
- `ripgrep` - For telescope live grep
- (Optional) A [Nerd Font](https://www.nerdfonts.com/) for icons

**First Steps After Installation:**
1. Launch Neovim: `nvim`
2. Wait for plugins to install automatically
3. Restart Neovim
4. Run `:checkhealth` to verify installation
5. Run `:Tutor` to learn Neovim basics

**Key Commands:**
- `:Lazy` - Manage plugins
- `:Mason` - Install LSP servers, formatters, linters
- `:checkhealth` - Diagnose issues
- `<space>sh` - Search help documentation

## Installation

### Install Neovim

Kickstart.nvim targets *only* the latest
['stable'](https://github.com/neovim/neovim/releases/tag/stable) and latest
['nightly'](https://github.com/neovim/neovim/releases/tag/nightly) of Neovim.
If you are experiencing issues, please make sure you have the latest versions.

### Install External Dependencies

External Requirements:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on the platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
- Emoji fonts (Ubuntu only, and only if you want emoji!) `sudo apt install fonts-noto-color-emoji`
- Language Setup:
  - If you want to write Typescript, you need `npm`
  - If you want to write Golang, you will need `go`
  - etc.

> [!NOTE]
> See [Install Recipes](#Install-Recipes) for additional Windows and Linux specific notes
> and quick install snippets

### Install Kickstart

> [!NOTE]
> [Backup](#FAQ) your previous configuration (if any exists)

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%localappdata%\nvim\` |
| Windows (powershell)| `$env:LOCALAPPDATA\nvim\` |

#### Recommended Step

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repo
so that you have your own copy that you can modify, then install by cloning the
fork to your machine using one of the commands below, depending on your OS.

> [!NOTE]
> Your fork's URL will be something like this:
> `https://github.com/<your_github_username>/kickstart-modular.nvim.git`

You likely want to remove `lazy-lock.json` from your fork's `.gitignore` file
too - it's ignored in the kickstart repo to make maintenance easier, but it's
[recommended to track it in version control](https://lazy.folke.io/usage/lockfile).

#### Clone kickstart.nvim

> [!NOTE]
> If following the recommended step above (i.e., forking the repo), replace
> `dam9000` with `<your_github_username>` in the commands below

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/dam9000/kickstart-modular.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone https://github.com/dam9000/kickstart.nvim.git "%localappdata%\nvim"
```

If you're using `powershell.exe`

```
git clone https://github.com/dam9000/kickstart.nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

### Post Installation

Start Neovim

```sh
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
the current plugin status. Hit `q` to close the window.

#### Read The Friendly Documentation

Read through the `init.lua` file in your configuration folder for more
information about extending and exploring Neovim. That also includes
examples of adding popularly requested plugins.

> [!NOTE]
> For more information about a particular plugin check its repository's documentation.


### Getting Started

[The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o)

## Plugins Overview

This configuration includes several carefully selected plugins that provide a powerful development experience. Below is an overview of the main plugins and their purposes:

### Core Plugins (Enabled by Default)

#### Plugin Manager
- **[lazy.nvim](https://github.com/folke/lazy.nvim)** - Fast and modern plugin manager that automatically installs and manages all plugins

#### LSP (Language Server Protocol)
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - Quickstart configurations for Neovim's built-in LSP client
- **[mason.nvim](https://github.com/mason-org/mason.nvim)** - Portable package manager for LSP servers, formatters, and linters
- **[mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim)** - Bridges mason.nvim with lspconfig
- **[mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)** - Automatically installs LSP servers and tools
- **[fidget.nvim](https://github.com/j-hui/fidget.nvim)** - Shows LSP progress notifications
- **[lazydev.nvim](https://github.com/folke/lazydev.nvim)** - Configures Lua LSP for Neovim config development

**Prerequisites for LSP:**
- Language servers are automatically installed via Mason for configured languages (Lua, Bash, Clangd)
- For additional languages, you may need to install language-specific tools:
  - **TypeScript/JavaScript**: Node.js and npm
  - **Python**: Python 3 and pip
  - **Go**: Go compiler
  - **C/C++**: Clang or GCC compiler

#### Autocompletion
- **[blink.cmp](https://github.com/saghen/blink.cmp)** - Fast and feature-rich autocompletion plugin
- **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)** - Snippet engine for expanding code snippets

**Prerequisites for blink.cmp:**
- Optional: Rust compiler for faster fuzzy matching (configuration uses Lua implementation by default)
- `make` for building LuaSnip's regex support (Windows users may need to disable this)

#### Fuzzy Finder
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Highly extendable fuzzy finder for files, buffers, LSP symbols, and more
- **[telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)** - FZF sorter for telescope (faster sorting)
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** - Lua utility functions (dependency for telescope)

**Prerequisites for Telescope:**
- `ripgrep` - Required for live grep functionality
- `fd` (optional) - For faster file finding
- `make` - Required to build telescope-fzf-native

#### Syntax Highlighting
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Advanced syntax highlighting and code parsing

**Prerequisites for Treesitter:**
- C compiler (gcc/clang) - Required to compile treesitter parsers
- `git` - Required to download parsers

#### Formatting
- **[conform.nvim](https://github.com/stevearc/conform.nvim)** - Lightweight and fast code formatter
- **stylua** - Lua formatter (automatically installed via Mason)

**Prerequisites for conform:**
- Language-specific formatters can be installed via Mason or manually:
  - **Python**: `black`, `isort`
  - **JavaScript/TypeScript**: `prettier`, `prettierd`
  - **Go**: `gofmt`, `goimports`

#### Git Integration
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - Git integration showing changes in the sign column

**Prerequisites for gitsigns:**
- `git` - Required for git functionality

#### UI Enhancements
- **[which-key.nvim](https://github.com/folke/which-key.nvim)** - Displays available keybindings in a popup
- **[todo-comments.nvim](https://github.com/folke/todo-comments.nvim)** - Highlights TODO, FIXME, and other comments
- **[mini.nvim](https://github.com/echasnovski/mini.nvim)** - Collection of minimal, independent plugins

#### Other Plugins
- **[vim-sleuth](https://github.com/tpope/vim-sleuth)** - Automatically detects indentation settings

### Optional Plugins (Disabled by Default)

The following plugins are included in the repository and commented out in `lua/lazy-plugins.lua`. To enable them, uncomment the desired plugin line:

- **debug** (`lua/kickstart/plugins/debug.lua`) - DAP (Debug Adapter Protocol) integration for debugging
- **indent_line** (`lua/kickstart/plugins/indent_line.lua`) - Shows indent guides
- **lint** (`lua/kickstart/plugins/lint.lua`) - Asynchronous linting
- **autopairs** (`lua/kickstart/plugins/autopairs.lua`) - Automatically inserts matching brackets and quotes

> [!NOTE]
> The `lua/lazy-plugins.lua` file may reference other plugins (like neo-tree) that are not included in this repository. Only enable plugins that have corresponding files in `lua/kickstart/plugins/`. You can check which plugins are available by viewing the files in that directory.

Example - to enable the debug plugin, edit `lua/lazy-plugins.lua`:
```lua
-- Change this:
-- require 'kickstart.plugins.debug',

-- To this:
require 'kickstart.plugins.debug',
```

### Custom Plugins

You can add your own plugins by creating files in `lua/custom/plugins/`. Each file should return a plugin specification. The configuration automatically imports all plugins from this directory.

Example (`lua/custom/plugins/my-plugin.lua`):
```lua
return {
  'author/plugin-name',
  config = function()
    -- Plugin configuration
  end,
}
```

## Mason Setup

Mason is used to automatically install and manage LSP servers, formatters, and linters. After the first launch:

1. Open Mason with `:Mason`
2. Press `g?` to see help
3. Navigate with `j`/`k`, install with `i`, uninstall with `X`

Currently configured language servers:
- `lua_ls` - Lua language server
- `bashls` - Bash language server
- `clangd` - C/C++ language server

To add more language servers, edit `lua/kickstart/plugins/lspconfig.lua` and add entries to the `servers` table.

## Troubleshooting

### Common Issues

**Issue**: Plugins not installing
- **Solution**: Run `:Lazy sync` to synchronize plugins

**Issue**: LSP not working
- **Solution**: Run `:Mason` to check if the language server is installed
- **Solution**: Run `:checkhealth` to diagnose LSP issues

**Issue**: Treesitter parsers failing to compile
- **Solution**: Ensure you have a C compiler installed (gcc/clang)
- **Solution**: Run `:checkhealth nvim-treesitter` for detailed diagnostics

**Issue**: Telescope grep not working
- **Solution**: Install `ripgrep` (see External Dependencies section)

**Issue**: Icons not displaying correctly
- **Solution**: Install a [Nerd Font](https://www.nerdfonts.com/) and set `vim.g.have_nerd_font = true` in `init.lua`

**Issue**: Build errors on Windows
- **Solution**: See [Windows Installation](#windows-installation) for platform-specific build tools

For more detailed diagnostics, run `:checkhealth` in Neovim.

### FAQ

* What should I do if I already have a pre-existing Neovim configuration?
  * You should back it up and then delete all associated files.
  * This includes your existing init.lua and the Neovim files in `~/.local`
    which can be deleted with `rm -rf ~/.local/share/nvim/`
* Can I keep my existing configuration in parallel to kickstart?
  * Yes! You can use [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME)`=nvim-NAME`
    to maintain multiple configurations. For example, you can install the kickstart
    configuration in `~/.config/nvim-kickstart` and create an alias:
    ```
    alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
    ```
    When you run Neovim using `nvim-kickstart` alias it will use the alternative
    config directory and the matching local directory
    `~/.local/share/nvim-kickstart`. You can apply this approach to any Neovim
    distribution that you would like to try out.
* What if I want to "uninstall" this configuration:
  * See [lazy.nvim uninstall](https://lazy.folke.io/usage#-uninstalling) information
* Why is the kickstart `init.lua` a single file? Wouldn't it make sense to split it into multiple files?
  * The main purpose of kickstart is to serve as a teaching tool and a reference
    configuration that someone can easily use to `git clone` as a basis for their own.
    As you progress in learning Neovim and Lua, you might consider splitting `init.lua`
    into smaller parts. A fork of kickstart that does this while maintaining the
    same functionality is available here:
    * [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)
  * *NOTE: This is the fork that splits the configuration into smaller parts.*
    The original repo with the single `init.lua` file is available here:
    * [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
  * Discussions on this topic can be found here:
    * [Restructure the configuration](https://github.com/nvim-lua/kickstart.nvim/issues/218)
    * [Reorganize init.lua into a multi-file setup](https://github.com/nvim-lua/kickstart.nvim/pull/473)

### Install Recipes

Below you can find OS specific install instructions for Neovim and dependencies.

After installing all the dependencies continue with the [Install Kickstart](#Install-Kickstart) step.

#### Windows Installation

<details><summary>Windows with Microsoft C++ Build Tools and CMake</summary>
Installation may require installing build tools and updating the run command for `telescope-fzf-native`

See `telescope-fzf-native` documentation for [more details](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation)

This requires:

- Install CMake and the Microsoft C++ Build Tools on Windows

```lua
{'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
```
</details>
<details><summary>Windows with gcc/make using chocolatey</summary>
Alternatively, one can install gcc and make which don't require changing the config,
the easiest way is to use choco:

1. install [chocolatey](https://chocolatey.org/install)
either follow the instructions on the page or use winget,
run in cmd as **admin**:
```
winget install --accept-source-agreements chocolatey.chocolatey
```

2. install all requirements using choco, exit the previous cmd and
open a new one so that choco path is set, and run in cmd as **admin**:
```
choco install -y neovim git ripgrep wget fd unzip gzip mingw make
```
</details>
<details><summary>WSL (Windows Subsystem for Linux)</summary>

```
wsl --install
wsl
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>

#### Linux Install
<details><summary>Ubuntu Install Steps</summary>

```
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>
<details><summary>Debian Install Steps</summary>

```
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
```
</details>
<details><summary>Fedora Install Steps</summary>

```
sudo dnf install -y gcc make git ripgrep fd-find unzip neovim
```
</details>

<details><summary>Arch Install Steps</summary>

```
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim
```
</details>

