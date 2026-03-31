local copilot_server = {}
if vim.fn.has 'unix' == 1 then
  copilot_server = {
    type = 'binary',
    custom_server_filepath = 'copilot-language-server',
  }
end

require('copilot').setup {
  server = copilot_server,
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
    vim.fn.expand '~/dev/dpdk/drivers/net/msft_smartnic/',
  },
  panel = { enabled = false },
}
