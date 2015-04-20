#!/bin/bash
#
# Script originally by Jamo, modified by Pasi


ID_FILE=".tmcid"
API_VERSION=7

config() {
  echo "ARRR"
  echo -n "Server: "
  read server
  echo -n "Username: "
  read username
  echo -n "Password: "
  read -s password
  echo -e "SERVER=\"$server\"\nUSER=\"$username:$password\"" > $CONFIG_FILE
}

parse-cond() {
  echo $1 | sed -E "s/.*\"$2\":$3.*/\1/"
}

parse-string() {
  parse-cond "$1" "$2" '"([^"]+)"'
}

parse-int() {
  parse-cond "$1" "$2" '([0-9]+)'
}

tmc() {
  curl -sS --user "$USER" $@
}

#  key="exit"
#  grep -R -B 3 -A 3 $key $zip_name

show-exercise() {
  id=$(parse-int "$1" 'id')
  user_id=$(parse-int "$1" 'user_id')
  ex_name=$(parse-string "$1" 'exercise_name')
  url="$SERVER/submissions/$id.zip"
#  url="https://tmc.mooc.fi/staging/submissions/$id.zip"
  echo
  echo "user: $id ex: $ex_name zip: $url"
  zip_name="$id-$user_id-$ex_name"
  if [ ! -d "$zip_name" ]; then
    mkdir $zip_name
    tmc -o "$zip_name/$zip_name.zip" $url
    cd $zip_name
    unzip -qq "$zip_name.zip"
    rm -rf "$zip_name.zip"
    cd ..
  fi
  #grep-magic $zip_name $user_id $ex_name
}

list-submissions() {
  url=$(parse-string "$1" 'exercise_submissions_url')
  tmc $url | grep -Eo '"submissions":\[.*\]' | grep -Eo '\{[^}]+\}' | while read exercise; do
  (show-exercise $exercise) &
  done
}

list-exid() {
    url="$SERVER/exercises/$1.json?api_version=$API_VERSION"
    tmc $url | grep -Eo '"submissions":\[.*\]' | grep -Eo '\{[^}]+\}' | while read exercise; do
       (show-exercise $exercise) &
    done
}

course-list-submissions() {
  tmc "$SERVER/courses/$1.json?api_version=$API_VERSION" | grep -Eo '"exercises":\[.*\]' | grep -Eo '\{[^}]+\}' | while read exercise; do
    list-submissions "$exercise"
  done
}

CONFIG_PATH="conf"
CONFIG_FILE="$CONFIG_PATH/settings"
if [ -f "$CONFIG_FILE" ]; then
  source $CONFIG_FILE
else
  config
fi

# From original Jamo's script: fetch all. I'm only doing one exercise at a time
#course-list-submissions $1

list-exid $1
