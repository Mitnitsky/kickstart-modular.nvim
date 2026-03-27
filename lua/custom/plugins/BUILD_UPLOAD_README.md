a# Build & Upload Plugin

This plugin integrates build and upload functionality from tmux into Neovim, providing convenient keybindings and commands to build your project and upload binaries.

## Features

- **Build Command**: Executes `buildAndZip.sh` script with DPDK initialization
- **Upload Command**: Runs `upload_binaries.py` with IP selection
- **Configurable Split Types**: Choose between horizontal, vertical, or popup terminal windows
- **Quick Keybindings**: Easy-to-remember key combinations

## Requirements

- `buildAndZip.sh` script in your project directory (for build functionality)
- `upload_binaries.py` script in your project directory (for upload functionality)
- `init_dpdk.sh` script in your project directory (sourced during build)

## Configuration

The plugin can be configured in the setup function. Default configuration:

```lua
require('custom.plugins.build-upload').setup {
  split_type = 'horizontal', -- Default split type: 'horizontal', 'vertical', or 'popup'
  split_size = 0.3,          -- 30% of screen for horizontal/vertical splits
  popup_width = 0.8,         -- 80% of screen width for popup
  popup_height = 0.6,        -- 60% of screen height for popup
}
```

You can customize these in [`lua/custom/plugins/build-upload.lua`](lua/custom/plugins/build-upload.lua:141-148).

## Keybindings

### Build Commands
- `<leader>bb` - Build project (using default split type)
- `<leader>bh` - Build project (horizontal split)
- `<leader>bv` - Build project (vertical split)
- `<leader>bp` - Build project (popup window)

### Upload Commands
- `<leader>uu` - Upload binaries (using default split type, shows IP selection menu)
- `<leader>uh` - Upload binaries (horizontal split)
- `<leader>uv` - Upload binaries (vertical split)
- `<leader>up` - Upload binaries (popup window)

## Commands

### `:Build [split_type]`
Executes the build script in a terminal.

**Examples:**
```vim
:Build              " Uses default split type
:Build horizontal   " Opens in horizontal split
:Build vertical     " Opens in vertical split
:Build popup        " Opens in popup window
```

### `:Upload [split_type]`
Executes the upload script with IP selection.

**Examples:**
```vim
:Upload             " Uses default split type
:Upload horizontal  " Opens in horizontal split
:Upload vertical    " Opens in vertical split
:Upload popup       " Opens in popup window
```

## Upload IP Selection

When you run the upload command, you'll be presented with a menu to select the target IP:
- `10.33.17.10`
- `10.190.120.157`

You can add more IPs by modifying the [`M.upload()`](lua/custom/plugins/build-upload.lua:75-103) function.

## Migration from Tmux

This plugin replaces the following tmux bindings:
- Tmux `prefix + b` → Neovim `<leader>bb` (build)
- Tmux `prefix + u` → Neovim `<leader>uu` (upload)

## Terminal Behavior

- The terminal automatically enters insert mode when opened
- After the command finishes, press `<Enter>` to close the terminal
- Press `<Esc><Esc>` to exit terminal mode without closing
- Use `<C-h/j/k/l>` to navigate between windows

## Customization

### Adding More IP Addresses

Edit [`lua/custom/plugins/build-upload.lua`](lua/custom/plugins/build-upload.lua:75-103) and modify the IP list in the `M.upload()` function:

```lua
vim.ui.select({
  '10.33.17.10',
  '10.190.120.157',
  '192.168.1.100',  -- Add your IPs here
}, { ... })
```

### Changing Default Split Type

Edit the setup configuration:

```lua
require('custom.plugins.build-upload').setup {
  split_type = 'vertical', -- Change to vertical by default
}
```

### Customizing Build/Upload Commands

Modify the `cmd` variable in the [`M.build()`](lua/custom/plugins/build-upload.lua:58-71) or [`M.upload()`](lua/custom/plugins/build-upload.lua:75-103) functions to customize the executed commands.
