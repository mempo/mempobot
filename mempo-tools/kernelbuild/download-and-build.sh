#!/bin/bash

echo
echo "Going to start the Mempo secure kernel build. In case of trouble read all on http://mempo.org (or .i2p for i2p anonymous network) and ask us on IRC (wait for reply!)"
echo 

flavour=$1
git_user=$2
advanced="$3"
advanced_opt="$4"

cmd="git-gpg-check"
if [[ ! -x $(which $cmd) ]] ; then { echo "No command ($cmd) is not found/not executable. You need to install this program and add to PATH. See the readme."  ; exit 1 ; } fi

thedir="$HOME/deterministic-kernel"

const_default_git_user='mempo';

if [[ -z "$flavour" ]] ; then echo "Specify the flavour to build (as command line argument nr 1 to this script), like desk or deskmax, or use the word 'none' to just download/prepare"; exit 1 ; fi
if [[ -z "$git_user" ]] ; then git_user="$const_default_git_user" ; fi

echo "Will build kernel:"
echo "  flavour=$flavour"
echo "  git_user=$git_user"

function help_usage_download_and_build() {
	echo "Usage of download_and_build.sh:"
	echo "argument 1 is the flavour like deb7/desk"
	echo "argument 2 can be empty, or is the name of git-user, default value is: $const_default_git_user"
	echo "argument 3 can be empty, or --check-hash" 
	echo "argument 4 can be empty, or for --check-hash it should be the full hash e.g. v0.1.92-01-released-4-g7c2d521b6ff4d208d1b325bcaf7ef334790453f1"
	echo ""
	echo "Examples:"
	echo "download-and-build.sh deb7/desk"
	echo "download-and-build.sh deb7/desk myuser --check-hash v0.1.92-01-released-4-g7c2d521b6ff4d208d1b325bcaf7ef334790453f1"
	echo "# obtain the long hash in git with command git describe --long --abbrev=1024"
	echo "# the 1024 char hash is just for 'super long hash' if in future git will add more hashes, e.g. some sha-1024 in 2020 year"
}

function help_git_hash() {
	echo ""
	echo "Help:"
	echo "We will verify if the gpg key is a key that we (the user who builds kernel) trusts."
	echo "Other option is to instead give the expected exact hash of the commit we want to build."
	echo "Go to the git repository where it is checked out, and obtain it's checksum with command:"
	echo "git describe --long --abbrev=1024"
	echo "And now call the script with added argument '--check-hash' and next argument with the full hash"
	echo ""
	echo "See usage."
	echo ""
	help_usage_download_and_build
}

function help_git_gpg() {
	help_git_hash
}

cd ~
rm -rf "$thedir" 
git clone "https://github.com/$git_user/deterministic-kernel.git" || { echo "ERROR: Failed to git clone" ; exit 1 ; }
cd "$thedir" || { echo "ERROR: Can not enter $thedir" ; exit 1 ; } 

gpg_was_ok=nope

if [[ "$advanced" == "--check-hash" ]] ; 
then

	git_hashname_now=$(git describe --long --abbrev=1024)
	echo "git long describe hashname is git_hashname_now=$git_hashname_now"
	git_hashname_good="$advanced_opt"
	echo "expected is git_hashname_good=$git_hashname_good"

	if [[ "x$git_hashname_now" == "x$git_hashname_good" ]] ; then
		gpg_was_ok='yes'
		echo "Git hash is as expected"
	else
		gpg_was_ok='no'
		echo "WARNING: Git hash is INVALID (not as expected)"
		help_git_hash
		# exit below
	fi

elif [[ "$advanced" == "" ]]  ;
then
# normal: check gpg key, no advanced options given

	git_tag=$( git describe --tags )
	echo "This is git tag: $git_tag"
	echo "Will verify this tag:"
	( LANG=C git tag -v $git_tag 3>&1 1>&2- 2>&3- ) | git-gpg-check -c && { echo GPG_OK ; gpg_was_ok="yes" ; } || { 
		echo GPG_CHECK_FAILED ; 
		echo "GPG check failed, make sure you have the GPG key and you trust it" ; 
		}

else
	echo "The advanced option is invalid, see usage".
	help_usage_download_and_build
	exit 100
fi


if [[ "x$gpg_was_ok" == "xyes" ]] ; then
	echo "GPG verified, ok"
else
	echo "GPG NOT VERIFIED XXXXX (double-checked)"
	help_git_gpg
	exit 51
fi

if [[ $flavour == 'none' ]] ;
then
	ls "$thedir"
	echo "Ok all done, not building anything as requested."
	echo "Files are ready in: $thedir"
else

	echo "Ok starting build script:"
	./run-flavour.sh "$flavour"

	echo "Build process finished, will now publish"
	mkdir -p ~/publish/

# we are in deterministic-kernel/
	cp -v kernel-build/linux-mempo/*deb ~/publish/ && echo "Copied the files" 

fi

echo
echo

