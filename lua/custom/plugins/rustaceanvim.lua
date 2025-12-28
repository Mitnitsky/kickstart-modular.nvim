return {
  'mrcjkb/rustaceanvim',
  version = '^5', -- Recommended
  lazy = false, -- This plugin is already lazy
  -- ,
  config = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
        -- Add any tool-specific configurations here
      },
      -- LSP configuration
      server = {
        on_attach = function(_, _)
          -- you can also put keymaps in here
        end,
        default_settings = {

          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
            cargo = {
              target = 'aarch64-unknown-linux-gnu',
              -- extraEnv = {
              --   CONSUMER_RDMA_DIR = '/home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/RDMA/linux/consumer',
              --   CARGO_TARGET_DIR = '/home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/build/RDMA/linux/consumer/rust-consumer/target',
              -- },
            },
            runnables = {
              extraArgs = {
                '--verbose',
                '--target',
                'aarch64-unknown-linux-gnu',
              },
              extraEnv = {
                TARGET_SOC = '10.33.17.10',
              },
            },
            check = {
              command = 'cargo clippy -- -D warnings',
            },
          },
        },
      },
      -- DAP configuration
      dap = {
        -- Add any DAP-specific configurations here
      },
    }
  end,
  opts = {
    env = {
      BINDGEN_EXTRA_CLANG_ARGS_aarch64_unknown_linux_gnu = '--sysroot=/opt/msft/2008.6.23120501/sysroots/aarch64-msft-linux',
      CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER = 'aarch64-msft-linux-gcc',
      CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_RUSTFLAGS = '-C link-arg=--sysroot=/opt/msft/2008.6.23120501/sysroots/aarch64-msft-linux',
      -- CARGO_TARGET_DIR = '/home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/build/RDMA/linux/consumer/rust-consumer/target',
      -- CONSUMER_RDMA_DIR = '/home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/RDMA/linux/consumer/',
      OECORE_TARGET_SYSROOT = '/opt/msft/2008.6.23120501/sysroots/aarch64-msft-linux',
    },
  },
}
