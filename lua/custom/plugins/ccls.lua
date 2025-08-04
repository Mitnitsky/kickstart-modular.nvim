return {
  'ranjithshegde/ccls.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
  },
  config = function()
    local lspconfig = require 'lspconfig'

    lspconfig.ccls.setup {
      init_options = {
        cache = {
          directory = '/tmp/ccls-cache',
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
      filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = function(client, bufnr)
        -- Optional: Add key mappings or other setup here
      end,
      root_dir = function(fname)
        -- Find project root (parent directory of the src/ folder)
        local root = lspconfig.util.root_pattern('.git', 'compile_commands.json')(fname)

        -- If we found a root but compile_commands.json is in src/build,
        -- ensure we're using the actual project root
        if root and vim.fn.filereadable(root .. '/src/build/compile_commands.json') == 1 then
          return root
        end

        return lspconfig.util.find_git_ancestor(fname)
      end,
    }
  end,
}
