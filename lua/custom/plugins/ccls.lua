return {
  'ranjithshegde/ccls.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
  },
  ft = { 'c', 'cpp', 'objc', 'objcpp', 'opencl' },
  config = function()
    local util = require 'lspconfig.util'

    -- Configure ccls using the new Neovim 0.11 API
    vim.lsp.config('ccls', {
      cmd = { 'ccls' },
      filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'opencl' },
      root_dir = util.root_pattern('.git', 'compile_commands.json', 'compile_flags.txt'),
      init_options = {
        cache = {
          directory = vim.fs.normalize '~/.cache/ccls/',
        },
        compilationDatabaseDirectory = 'src/build',
        index = {
          threads = 0, -- Use all available threads for indexing
        },
        clang = {
          -- Cross compiler configuration based on your compile_commands.json
          extraArgs = {
            '--gcc-toolchain=/opt/msft/2008.6.23120501/sysroots/x86_64-msftsdk-linux/usr/bin/aarch64-msft-linux/aarch64-msft-linux-gcc',
            '--sysroot=/opt/msft/2008.6.23120501/sysroots/aarch64-msft-linux',
            '--target=aarch64-msft-linux',
            '-march=armv8-a+crc',
            '-mcpu=cortex-a72',
            '-fstack-protector-strong',
            '-fstack-clash-protection',
            '-Wformat',
            '-Wformat-security',
            '-Werror=format-security',
            '-DSOCBLD',
            '-DALLOW_EXPERIMENTAL_API',
            '-DSOCBLD_PENDING_HOST_SUPPORT_REMOVAL',
            '-DDBG=1',
          },
          excludeArgs = {},
          resourceDir = '/opt/msft/2008.6.23120501/sysroots/x86_64-msftsdk-linux/usr/lib/aarch64-msft-linux/gcc/aarch64-msft-linux/11.2.0/include',
        },
        completion = {
          placeholder = true,
          detailedLabel = true,
        },
      },
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = function(client, bufnr)
        -- Optional: Add key mappings or other setup here
      end,
    })

    -- Enable ccls for the specified filetypes
    vim.lsp.enable 'ccls'
  end,
}
