return {
  'mbbill/undotree',
  keys = {
    -- Define a keymap to toggle the undotree window
    { '<leader>tu', '<cmd>UndotreeToggle<cr>', desc = '[T]oggle [u]ndotree' },
    -- You might want other keymaps related to navigating the undotree window
    -- For example, to easily step forward/backward in history
    -- See :help undotree-commands
  },
  cmd = 'UndotreeToggle', -- Only load the plugin when this command is used
  init = function()
    -- Optional: Configure Undotree settings

    -- For example, to set the undotree window size
    vim.g.undotree_diff_view_options = [[-p --color-moved=plain]] -- Example: make diff more readable
    vim.g.undotree_split_width = 40 -- Example: Set the widpth of the undotree window
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_auto_refresh = 1 -- Example: Auto-refresh the tree
    vim.opt.undodir = os.getenv 'HOME' .. '/.nvim/undodir' -- Or wherever you want to store undo files
    vim.opt.undofile = true
    vim.opt.undolevels = 10000 -- Optional: increase default history depth
    vim.opt.undoreload = 100000 -- Optional: increase buffer size for saving history
    -- See :help undotree-options for more options
  end,
}
