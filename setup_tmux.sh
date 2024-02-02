#!/bin/bash

# Define the path to the tmux configuration file
TMUX_CONFIG="$HOME/.tmux.conf"

# Backup the current tmux configuration, if it exists
if [ -f "$TMUX_CONFIG" ]; then
    cp "$TMUX_CONFIG" "${TMUX_CONFIG}.backup"
    echo "Existing tmux.conf backed up to tmux.conf.backup"
fi

# Write the custom tmux configuration to the tmux.conf file
cat > "$TMUX_CONFIG" <<'EOF'
# Set the prefix, assuming the default Ctrl+B
# If you've changed this, adjust the prefix key accordingly
set -g prefix C-b
unbind C-b
bind C-b send-prefix

# Function keys for common actions
bind -n F1 new-window # Create a new window
bind -n F2 split-window -h # Split the current pane horizontally
bind -n F3 split-window -v # Split the current pane vertically
bind -n F4 select-pane -t :.+ # Move to the next pane
bind -n F5 select-pane -t :.- # Move to the previous pane
bind -n F6 detach-client # Detach the current client
bind -n F7 previous-window # Move to the previous window
bind -n F8 next-window # Move to the next window
bind -n F9 list-sessions # List all sessions
bind -n F10 last-window # Toggle between the last active windows
bind -n F11 kill-window # Close the current window
bind -n F12 kill-pane # Close the current pane

# Numpad keys for pane navigation and resizing
bind -n KP0 select-layout even-horizontal
bind -n KP1 select-pane -L
bind -n KP2 select-pane -D
bind -n KP3 select-pane -U
bind -n KP4 select-pane -R
bind -n KP5 resize-pane -D 5
bind -n KP6 resize-pane -U 5
bind -n KP7 resize-pane -L 5
bind -n KP8 resize-pane -R 5
bind -n KP9 swap-pane -s 1 -t 2

# Ensure tmux recognizes numpad keys (may depend on terminal emulator)
set -g terminal-overrides 'xterm*:smkx@:rmkx@'

# Reload tmux config with a simple key binding
bind -n F24 source-file ~/.tmux.conf \; display-message "Config reloaded!"
EOF

echo "Custom tmux configuration for macro-friendly keybindings has been applied."
echo "Please reload your tmux configuration by running:"
echo "tmux source-file ~/.tmux.conf"
echo "Or, restart your tmux session."
