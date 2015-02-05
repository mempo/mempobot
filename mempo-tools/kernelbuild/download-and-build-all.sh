#!/bin/bash

echo
echo "Going to start the Mempo secure kernel build. In case of trouble read all on http://mempo.org (or .i2p for i2p anonymous network) and ask us on IRC (wait for reply!)"
echo "=== GOING to build ALL FLAVOURS ==="
echo 

const_default_git_user='mempo'

function help_usage_download_and_build_all() {
	echo "Usage of download_and_build.sh:"
	echo "argument 1 is the name of git-user. E.g. use: $const_default_git_user"
	echo "argument 2 can be empty, or --check-hash" 
	echo "argument 3 can be empty, or for --check-hash it should be the full hash"
	echo ""
	echo "Examples:"
	echo "download-and-build-all.sh"
	echo "download-and-build-all.sh deb7/desk myuser --check-hash v0.1.92-01-released-4-g7c2d521b6ff4d208d1b325bcaf7ef334790453f1"
	echo ""
	echo "Use this (invalid) command to see more help, yes call the other script here:"
	echo "download-and-build.sh deb7/desk myuser --check-hash"
}

git_user=$1
if [[ -z "$git_user" ]] ; then 
	echo 'Specify the flavour to build (as command line argument nr 1 to this script), like mempo or rfree (for github.com/rfree/)'
	help_usage_download_and_build_all
	exit 1
fi
advanced="$2"
advanced_opt="$3"

echo "Building for user:"
echo "git_user=$git_user"
echo "advanced=$advanced" 
echo "advanced_opt=$advanced_opt" 

for flavour in 'deb7/servmax' 'deb7/servmaxdbg' 'deb7/deskmax' 'deb7/desk' 'deb7/serv' 'deb7/deskmaxdbg' 'deb7/insecuregrsoff' 'deb7/zero'
do
	./download-and-build.sh "$flavour" "$git_user" "$advanced" "$advanced_opt"
done

