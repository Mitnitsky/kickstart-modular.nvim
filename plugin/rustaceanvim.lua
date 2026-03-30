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
