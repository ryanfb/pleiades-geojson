#!/bin/bash

# needed for ssh-agent auth under cron on OS X
declare -x SSH_AUTH_SOCK=$( find /tmp/com.apple.launchd.*/Listeners -user $(whoami) -type s | head -1 )

git checkout master
git pull
./update.sh
git add geojson
git add name_index.json
git commit -m "$(date '+%Y-%m-%d') GeoJSON update"
git checkout gh-pages
git pull
git merge master
git push
git checkout master
