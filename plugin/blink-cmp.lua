require('blink.cmp').setup {
  keymap = {
    preset = 'enter',
    ['<C-q>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<Tab>'] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      'snippet_forward',
      'fallback',
    },
    ['<CR>'] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      'snippet_forward',
      'fallback',
    },
  },
  appearance = {
    nerd_font_variant = 'mono',
    kind_icons = {
      Copilot = '',
      Text = '󰉿',
      Method = '󰊕',
      Function = '󰊕',
      Constructor = '󰒓',
      Field = '󰜢',
      Variable = '󰆦',
      Property = '󰖷',
      Class = '󱡠',
      Interface = '󱡠',
      Struct = '󱡠',
      Module = '󰅩',
      Unit = '󰪚',
      Value = '󰦨',
      Enum = '󰦨',
      EnumMember = '󰦨',
      Keyword = '󰻾',
      Constant = '󰏿',
      Snippet = '󱄽',
      Color = '󰏘',
      File = '󰈔',
      Reference = '󰬲',
      Folder = '󰉋',
      Event = '󱐋',
      Operator = '󰪚',
      TypeParameter = '󰬛',
    },
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 700 },
    list = {
      selection = { preselect = true, auto_insert = false },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}

require('blink.pairs').setup {
  mappings = { enabled = true, cmdline = true, disabled_filetypes = {}, pairs = {} },
  highlights = {
    enabled = true,
    cmdline = true,
    groups = { 'BlinkPairsOrange', 'BlinkPairsPurple', 'BlinkPairsBlue' },
    unmatched_group = 'BlinkPairsUnmatched',
    matchparen = {
      enabled = true,
      cmdline = false,
      include_surrounding = false,
      group = 'BlinkPairsMatchParen',
      priority = 250,
    },
  },
  debug = false,
}

require('luasnip').setup {}

require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}
