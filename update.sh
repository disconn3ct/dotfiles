#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

#git pull origin master;
# Pull in vim modules
#git submodule update --init
BACKDIR=~/dotfile-bak/$(date +'%Y%m%d-%H%M')
#BACKDIR=~/dotfile-bak/$(date -Iminutes)

function fakeIt() {
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
    -avh --no-perms . ~;
}

function doIt() {
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
    -avh --no-perms . ~;
  source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
elif [ "$1" == "--noop" -o "$1" == "-n" ]; then
  fakeIt;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
    echo "Backups (if needed) are saved to ${BACKDIR}"
  fi;
fi;
unset doIt;
unset fakeIt;
