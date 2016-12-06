#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;
# Pull in vim modules
git submodule update --init
BACKDIR=~/dotfile-bak/$(date -Iminutes)

function doIt() {
    mkdir -p "${BACKDIR}"
	rsync -b --backup-dir "${BACKDIR}" \
	    --exclude ".git/" \
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
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
		echo "Backups (if needed) are saved to ${BACKDIR}"
	fi;
fi;
unset doIt;
