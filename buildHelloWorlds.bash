#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SATRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	exit 201
}

_SATRPEXIT_() { # Run on exit.
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SATRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
 	exit 211 
}

_SATRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
 	exit 221 
}

trap '_SATRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SATRPEXIT_ EXIT
trap _SATRPSIGNAL_ HUP INT TERM 
trap _SATRPQUIT_ QUIT 
export DAY="$(date +%Y%m%d)"
export RDR="$HOME/buildAPKs"
export SRDR="${RDR:33}" # search.string: string manipulation site:www.tldp.org
JID=HelloWorlds
NUM="$(date +%s)"
JDR="$RDR/sources"
cd "$RDR"
git pull ||:
git submodule update --init ./scripts/shlibs ||:
. "$RDR/scripts/shlibs/lock.bash"
. "$RDR/pullBuildAPKsSubmodules.bash"
if [[ ! -f "$HOME/buildAPKs/sources/samples/.git" ]]
then
	echo
	echo "Updating buildAPKs; \`${0##*/}\` might want to load sources from submodule repositories into buildAPKs. This may take a little while to complete. Please be patient if this script wants to download source code from https://github.com"
	cd "$HOME/buildAPKs"
	git submodule update --init ./sources/samples
else
	echo
	echo "To update module ~/buildAPKs/sources/samples to the newest version remove the ~/buildAPKs/sources/samples/.git file and run ${0##*/} again."
fi

find $HOME/buildAPKs/sources/samples/helloWorlds/ \
       	-name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.bash HelloWorlds {} \; \
	2>"$HOME/buildAPKs/var/log/stnderr.${JID,,}.$NUM.log"
. "$RDR/scripts/shlibs/faa.bash" "$JID" "$JDR" ||:

#EOF
