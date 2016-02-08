#!/bin/bash
random_prefix=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
profile_dir=$HOME/.mozilla/firefox/$random_prefix.default
mkdir -p $profile_dir
touch $profile_dir/prefs.js
touch $profile_dir/times.json
chmod 700 $profile_dir/times.json
echo "{
\"created\": $(date +%s%N | cut -b1-13)
}" > $profile_dir/times.json
echo "[General]
StartWithLastProfile=1

[Profile0]
Name=default
IsRelative=1
Path=$random_prefix.default
" > $profile_dir/../profiles.ini
