#!/usr/bin/env bash
# Editor script for lazygit — opens files in Neovim.
#
# When running inside Neovim (embedded lazygit):
#   Sends the file to the parent Neovim instance via --remote.
#
# When running standalone in tmux:
#   Kills lazygit, opens Neovim at the git repo root with nvim-tree,
#   and drops back to a shell when Neovim exits.
#
# When running standalone without tmux:
#   Opens Neovim in the same terminal at the git repo root.
#
# Usage: edit-in-nvim.sh <filename> [line]

FILE="$1"
LINE="${2:-}"

if [ -n "$NVIM" ]; then
    # ── Embedded in Neovim: send file to parent instance ──
    if [ -n "$LINE" ]; then
        nvim --server "$NVIM" --remote-send \
            "<C-\\><C-n>:q | edit +${LINE} ${FILE}<CR>"
    else
        nvim --server "$NVIM" --remote-send "<C-\\><C-n>:q<CR>"
        nvim --server "$NVIM" --remote "$FILE"
    fi
elif [ -n "$TMUX" ]; then
    # ── Standalone + tmux: replace lazygit pane with Neovim ──
    REPO_ROOT="$(git rev-parse --show-toplevel)"
    LINE_ARG=""
    [ -n "$LINE" ] && LINE_ARG="+${LINE}"

    tmux respawn-pane -k \
        -c "$REPO_ROOT" \
        "nvim -c NvimTreeOpen ${LINE_ARG} -- ${FILE}; exec $SHELL"
else
    # ── Standalone, no tmux: open Neovim in place ──
    REPO_ROOT="$(git rev-parse --show-toplevel)"
    cd "$REPO_ROOT" || exit 1
    LINE_ARG=""
    [ -n "$LINE" ] && LINE_ARG="+${LINE}"

    exec nvim -c NvimTreeOpen ${LINE_ARG} -- "$FILE"
fi
