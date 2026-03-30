return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'zsh', 'bash' },
  root_markers = { '.bashrc', '.bash_profile', '.git' },
  settings = {
    bashIde = {
      shellcheckPath = 'shellcheck',
      shfmtPath = 'shfmt',
    },
  },
}
