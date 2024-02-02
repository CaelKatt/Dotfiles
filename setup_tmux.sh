#!/bin/bash

TMUX_CONFIG="$HOME/.tmux.conf"

# Backup existing tmux configuration
if [ -f "$TMUX_CONFIG" ]; then
    cp "$TMUX_CONFIG" "${TMUX_CONFIG}.backup"
    echo "Existing tmux.conf backed up."
fi

# Start writing the tmux configuration
cat > "$TMUX_CONFIG" <<'EOF'
# Set prefix to Ctrl+B (default)
set-option -g prefix C-b
unbind C-b
bind C-b send-prefix

# Custom keybindings for tmux commands
# Rename session
bind R command-prompt "rename-session '%%'"

# Detach from session
bind D detach-client

# Show all sessions
bind S list-sessions

# Session and Window Preview
bind W choose-tree

# Move to previous session
bind F1 switch-client -p

# Move to next session
bind F2 switch-client -n

# Create window
bind F3 new-window

# Rename current window
bind F4 command-prompt "rename-window '%%'"

# Close current window
bind F5 kill-window

# List windows
bind w list-windows

# Previous window
bind p previous-window

# Next window
bind n next-window

# Switch/select window by number
bind-key -T prefix 0 select-window -t :=0
bind-key -T prefix 1 select-window -t :=1
# Add bindings for 2-9 as needed

# Toggle last active window
bind l last-window

# Toggle last active pane
bind F6 select-pane -l

# Split the current pane horizontally
bind F7 split-window -h

# Split the current pane vertically
bind F8 split-window -v

# Move the current pane left
bind F9 swap-pane -U

# Move the current pane right
bind F10 swap-pane -D

# Toggle synchronize-panes
bind 0 setw synchronize-panes

# Toggle between pane layouts
bind Space next-layout

# Switch to next pane
bind o select-pane -t :.+

# Show pane numbers
bind q display-panes

# Toggle pane zoom
bind z resize-pane -Z

# Convert pane into a window
bind F11 break-pane -d

# Close current pane
bind x kill-pane

# Enter copy mode
bind F12 copy-mode

# Enter copy mode and scroll one page up
bind PageUp copy-mode -u

# Navigate panes with arrow keys
unbind o
bind -n Up select-pane -U
bind -n Down select-pane -D
bind -n Left select-pane -L
bind -n Right select-pane -R

EOF

echo "Custom tmux configuration applied. Please reload your tmux configuration."
