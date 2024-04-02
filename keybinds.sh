#!/bin/bash

# Command to run
COMMAND="i3lock"

# Keyboard shortcut to assign (e.g., "<Super><Shift>X")
KEYBIND="<Super>F6"

# Unique ID for the custom keybinding
UUID=$(uuidgen)

# The base path for custom keybindings in GNOME
BASE_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$UUID/"

# Step 1: Add the custom keybinding
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | sed -e "s/]$/, '$BASE_PATH']/")"

# Step 2: Set the name, command, and binding for the keybinding
gsettings set "$BASE_PATH" name "Custom Shortcut"
gsettings set "$BASE_PATH" command "$COMMAND"
gsettings set "$BASE_PATH" binding "$KEYBIND"

echo "Custom keybinding set: $KEYBIND to run '$COMMAND'"
