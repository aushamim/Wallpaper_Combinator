#!/bin/bash

parent_folder="$(dirname "$(realpath "$0")")"

source_folder="$parent_folder/Source"

main_log_file="$parent_folder/activities.log"
touch "$main_log_file"

log() {
    echo "$1" | tee -a "$main_log_file"
}

# Path to the script to run on changes
script_to_run="$parent_folder/generate_combinations.sh"

# Monitor the source folder for file changes (create, delete, modify, move)
inotifywait -m -r -e create -e delete -e modify -e moved_to -e moved_from "$source_folder" |
while read -r directory events filename; do
  log "[+]Change detected in $directory ($events on $filename)"
  # Run the script
  bash "$script_to_run"
done
