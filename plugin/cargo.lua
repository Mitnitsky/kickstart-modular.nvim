-- cargo.nvim requires a native library compiled with Cargo (Linux only)
if vim.fn.has 'unix' == 1 then
  require('cargo').setup {
    float_window = true,
    window_width = 0.8,
    window_height = 0.8,
    border = 'rounded',
    auto_close = false,
    close_timeout = 5000,
  }
end
