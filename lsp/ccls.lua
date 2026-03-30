return {
  cmd = { 'ccls' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'opencl' },
  root_markers = { '.git', 'compile_commands.json', 'compile_flags.txt' },
  init_options = {
    cache = {
      directory = vim.fs.normalize '~/.cache/ccls/',
    },
    compilationDatabaseDirectory = 'src/build',
    index = {
      threads = 0,
    },
    clang = {
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
}
