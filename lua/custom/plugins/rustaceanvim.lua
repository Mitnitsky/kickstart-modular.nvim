return {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function()
      -- Additional plugin configuration
      vim.g.rustaceanvim = {
        clippy = {
          env = {
            RUST_LOG = 'debug',
            CARGO_TARGET_DIR = '/home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/RDMA/linux/consumer/rust-consumer/target',
            RUST_BACKTRACE = '1',
            CLIPPY_ARGS = '--fix',
          },
        },
      }
    end,
    opts = {
      env = {
        BINDGEN_EXTRA_CLANG_ARGS_aarch64_unknown_linux_gnu = '--sysroot=/opt/msft/2008.6.23120501/sysroots/aarch64-msft-linux',
        CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER = 'aarch64-msft-linux-gcc',
        CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_RUSTFLAGS = '-C link-arg=--sysroot=/opt/msft/2008.6.23120501/sysroots/aarch64-msft-linux',
        CARGO_TARGET_DIR = '/home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/RDMA/linux/consumer/rust-consumer/target',
        CONSUMER_RDMA_DIR = '/home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/src/RDMA/linux/consumer/',
        OECORE_TARGET_SYSROOT = '/opt/msft/2008.6.23120501/sysroots/aarch64-msft-linux',
      },
    },
  }
