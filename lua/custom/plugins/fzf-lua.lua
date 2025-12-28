return {
  'ibhagwan/fzf-lua',
  on_attach = function(bufnr)
    local map = function(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end
  end,
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
