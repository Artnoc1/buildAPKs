#!/bin/env bash 
# Copyright 2019 (c) all rights reserved 
# by SDRausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SBDBTRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	set +Eeuo pipefail 
	exit 201
}

_SBDBTRPEXIT_() { # Run on exit.
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SBDBTRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
 	exit 211 
}

_SBDBTRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
 	exit 221 
}

trap '_SBDBTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SBDBTRPEXIT_ EXIT
trap _SBDBTRPSIGNAL_ HUP INT TERM 
trap _SBDBTRPQUIT_ QUIT 

JID=InDir
NUM="$(date +%s)"
WDR="$PWD"
. "$HOME/buildAPKs/scripts/shlibs/lock.bash"
_WAKELOCK_
find "$@" -name AndroidManifest.xml \
	-execdir /bin/bash "$HOME/buildAPKs/buildOne.bash" "$JID" "$WDR" {} \; \
	2> "$HOME/buildAPKs/var/log/stnderr.build."${JID,,}".$(date +%s).log"
_WAKEUNLOCK_
#	search: lowercase bash variable pattern replacement substitution site:tldp.org
#	http://www.tldp.org/LDP/abs/html/bashver4.html#CASEMODPARAMSUB
#EOF
