#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Update repository and update submodules.
#####################################################################
set -e 
cd "$HOME"/buildAPKs
if [[ ! -f "$HOME/buildAPKs/docs/.git" ]] || [[ ! -f "$HOME/buildAPKs/scripts/maintenance/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/applications/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/browsers/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/clocks/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/compasses/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/entertainment/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/flashlights/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/games/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/liveWallpapers/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/samples/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/top10/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/tools/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/tutorials/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/widgets/.git" ]]
then
	printf "\\n\\nUpdating buildAPKs\; \`%s\` might need to load sources from submodule repositories into buildAPKs. This may take a little while to complete. Please be patient if this script needs to download source code from https://github.com\\n" "${0##*/}"
	git pull 
	git submodule update --init -- ./docs
	git submodule update --init -- ./scripts/maintenance
	git submodule update --init -- ./sources/applications
	git submodule update --init -- ./sources/browsers 
	git submodule update --init -- ./sources/clocks
	git submodule update --init -- ./sources/compasses 
	git submodule update --init -- ./sources/entertainment
	git submodule update --init -- ./sources/flashlights 
	git submodule update --init -- ./sources/games 
	git submodule update --init -- ./sources/liveWallpapers
	git submodule update --init -- ./sources/samples 
	git submodule update --init -- ./sources/top10 
	git submodule update --init -- ./sources/tools 
	git submodule update --init -- ./sources/tutorials
	git submodule update --init -- ./sources/widgets
else
	printf "\\n\\nTo update the modules in ~/buildAPKs to the newest version remove one of these .git files:\\n\\n"
	find "$HOME/buildAPKs" -type f -name .git

fi

#EOF
