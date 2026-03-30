local M = {}

--- Parse SSH hosts from ~/.ssh/config
---@return string[]
function M.get_ssh_hosts()
  local hosts = {}
  local ssh_config = vim.fn.expand '~/.ssh/config'

  if vim.fn.filereadable(ssh_config) == 0 then
    return hosts
  end

  for line in io.lines(ssh_config) do
    local host = line:match '^Host%s+(%S+)'
    if host and host ~= '*' then
      table.insert(hosts, host)
    end
  end
  return hosts
end

return M
