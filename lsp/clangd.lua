return {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=never',
    '--completion-style=detailed',
    '--function-arg-placeholders',
    '--fallback-style=llvm',
    '--clang-tidy-checks=-*,readability-*,modernize-*,readability-identifier-naming-*',
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', '.git' },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  capabilities = {
    offsetEncoding = { 'utf-16' },
  },
}
