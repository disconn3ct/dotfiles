#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

BACKDIR=~/dotfile-bak/$(date +'%Y%m%d-%H%M')

function fakeIt() {
  # Explicitly ignores -t because time is relative
  rsync -b --backup-dir "${BACKDIR}" \
    --exclude ".git/" \
    --exclude ".vim/swaps/" \
    --exclude ".vim/backups/" \
    --exclude ".DS_Store" \
    --exclude ".osx" \
    --exclude "bootstrap.sh" \
    --exclude "README.md" \
    --exclude "LICENSE-MIT.txt" \
    --exclude "update.sh" \
    --dry-run \
    -rlpgoD -vh --no-perms . ~
}

function doIt() {
  # Explicitly ignores -t because time is relative and
  # its not useful to back up identical files over a timestamp
  mkdir -p "${BACKDIR}"
  rsync -b --backup-dir "${BACKDIR}" \
    --exclude ".git/" \
    --exclude ".vim/swaps/" \
    --exclude ".vim/backups/" \
    --exclude ".DS_Store" \
    --exclude ".osx" \
    --exclude "bootstrap.sh" \
    --exclude "README.md" \
    --exclude "LICENSE-MIT.txt" \
    --exclude "update.sh" \
    -rlpgoD -vh --no-perms . ~
  # shellcheck source=./.bash_profile
  source ~/.bash_profile
}

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  doIt
elif [ "$1" == "--noop" ] || [ "$1" == "-n" ]; then
  fakeIt
else
  read -rp "This may overwrite existing files in your home directory. Backups will be saved to ${BACKDIR}. Proceed? (y/n) " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt
    echo "Backups (if available) were saved to ${BACKDIR}"
  fi
fi
unset doIt
unset fakeIt
