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

# Pane splitting with numpad
bind -n KP_Multiply split-window -h # Numpad *
bind -n KP_Divide split-window -v # Numpad /

# Navigate panes with F keys
bind -n F1 select-pane -L
bind -n F2 select-pane -D
bind -n F3 select-pane -U
bind -n F4 select-pane -R

# Resize panes with shifted F keys (F5-F8)
bind -n F5 resize-pane -L 2
bind -n F6 resize-pane -D 2
bind -n F7 resize-pane -U 2
bind -n F8 resize-pane -R 2

# Create new window with F9
bind -n F9 new-window

# Navigate windows with F10 and F11
bind -n F10 next-window
bind -n F11 previous-window

# Detach session with F12
bind -n F12 detach-client

# Reload tmux config with Ctrl+F12 (assuming your terminal and OS can handle this combo)
bind -n C-F12 source-file ~/.tmux.conf \; display-message "Config reloaded!"

# List sessions with numpad +
bind -n KP_Add list-sessions

# Find window with numpad -
bind -n KP_Subtract command-prompt "find-window '%%'"

# Synchronize panes with numpad 0
bind -n KP_0 setw synchronize-panes

EOF

echo "Custom tmux configuration applied. Please reload your tmux configuration."
