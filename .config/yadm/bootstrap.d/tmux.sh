#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# Install tmux config, if ~/.tmux/tmux.conf is not present:
if [[ ! -f "${HOME}/.tmux/tmux.conf" ]]; then
  printf "Install TMUX config\n"
  cp -av ~/.tmux-config-git/tmux/* ~/.tmux
  # https://github.com/samoshkin/tmux-config/blob/master/install.sh#L37-L41
  printf "Install TPM plugins\n"
  tmux new -d -s __noop >/dev/null 2>&1 || true
  tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.tmux/plugins"
  "$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
  tmux kill-session -t __noop >/dev/null 2>&1 || true
fi
