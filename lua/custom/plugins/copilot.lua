return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          accept = '<M-a>',
          accept_word = false,

          accept_line = false,

          next = '<M-n>',
          prev = '<M-p>',
          dismiss = '<M-d>',
        },
      },

      workspace_folders = {
        '/home/vmitnitsky/dev/dpdk/drivers/net/msft_smartnic/',
      },
      panel = { enabled = false },
    }
  end,
}
