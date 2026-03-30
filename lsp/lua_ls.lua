return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', '.git' },
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      runtime = {
        version = 'LuaJIT',
      },
    },
  },
}
