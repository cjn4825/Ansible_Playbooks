#!/usr/bin/env bash

# script to link deploy.sh script to user home.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

SCRIPT="$REPO_ROOT/scripts/deploy.sh"
BIN="$HOME/.local/bin/deploy"

echo "Linking [$SCRIPT] -> [$BIN]"
rm -f "$BIN"
ln -sfn "$SCRIPT" "$BIN"

if [ -f "$HOME/.bashrc" ]; then
    shopt -s expand_aliases 2>/dev/null
    source "$HOME/.bashrc"
fi
