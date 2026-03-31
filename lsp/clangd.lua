return {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=never',
    '--completion-style=detailed',
    '--function-arg-placeholders',
    '--fallback-style=llvm',
    '--clang-tidy-checks=-*,readability-*,modernize-*,readability-identifier-naming-*,-readability-identifier-length',
    -- Cross-reference indexing for call hierarchy & type hierarchy
    '--cross-file-rename',
    -- Rank completions by how often they're used in nearby code
    '--ranking-model=decision_forest',
    -- Include cleaner diagnostics (suggest missing/unused includes)
    '--include-cleaner-stdlib',
    -- Limit memory usage on large codebases
    '--pch-storage=memory',
    '-j=4',
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
