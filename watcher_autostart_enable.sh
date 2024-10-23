#!/bin/bash

# Get the parent folder of the script
parent_folder="$(dirname "$(realpath "$0")")"

# Create the autostart directory if it doesn't exist
mkdir -p ~/.config/autostart

# Create a .desktop file for the watcher
cat <<EOL > ~/.config/autostart/wallpaper_combination_watcher.desktop
[Desktop Entry]
Type=Application
Exec=bash "$parent_folder/watcher.sh"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Image Combiner Watcher
EOL

# Make the scripts executable
chmod +x "$parent_folder/generate_combinations.sh"
chmod +x "$parent_folder/watcher.sh"

echo "Watcher script set to run on startup."
