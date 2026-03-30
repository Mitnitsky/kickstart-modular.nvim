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
    env = { RUST_GDB = '/usr/bin/gdb-multiarch' },
  },
}
