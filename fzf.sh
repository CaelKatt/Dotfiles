#!/bin/bash

# Define the file to append to
TARGET_FILE="$HOME/.bashrc"

# Function to add
FD_FUNCTION=$(cat <<- 'EOF'
fd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
                    -o -type d -print 2> /dev/null | fzf +m) && cd "$dir"
}
EOF
)

# Check if the function is already in the file
if grep -q "fd()" "$TARGET_FILE"; then
    echo "The fd() function is already added to $TARGET_FILE."
else
    echo "$FD_FUNCTION" >> "$TARGET_FILE"
    echo "The fd() function has been added to $TARGET_FILE."
fi
