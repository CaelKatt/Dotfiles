#!/bin/bash

# Verify running as a regular user, not root
if [ "$EUID" -eq 0 ]; then
    echo "This script must not be run as root. Please run as your regular user."
    exit
fi

# Install necessary packages (some commands need sudo)
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git gdm3 i3 i3blocks i3lock lxappearance materia-gtk-theme feh mc alacritty neovim xz-utils thunar neofetch gedit pulseaudio


#FLATPAKS
# File containing the list of Flatpak apps to install
FILE="flatpaks.txt"

# Check if the file exists
if [ ! -f "$FILE" ]; then
    echo "File not found: $FILE"
    exit 1
fi

# Loop through each line in the file
while IFS= read -r line; do
    # Install the Flatpak app
    echo "Installing $line..."
    flatpak install -y flathub "$line"
done < "$FILE"
# chmod +x install_flatpaks.sh
#!/bin/bash

# Define the actual username and home directory, even when running with sudo
REAL_USER=$(logname)
REAL_HOME=$(eval echo ~$REAL_USER)

# Define directories
bin_dir="$REAL_HOME/bin"
flatpak_list="flatpaks.txt"  # Ensure this path is correct or adjust accordingly

# Create bin directory if it doesn't exist
sudo -u $REAL_USER mkdir -p "$bin_dir"

# Function to create wrapper script for each Flatpak app
create_wrapper_script() {
    local app_id="$1"
    local app_name=$(echo "$app_id" | awk -F '.' '{print tolower($NF)}')
    local script_path="$bin_dir/$app_name"

    sudo -u $REAL_USER bash -c "echo -e '#!/bin/bash\nflatpak run $app_id' > '$script_path'"
    sudo -u $REAL_USER chmod +x "$script_path"
}

# Read each Flatpak app ID and create a wrapper script
while IFS= read -r line || [[ -n "$line" ]]; do
    create_wrapper_script "$line"
done < "$flatpak_list"

echo "Flatpak wrappers created. Please ensure $bin_dir is in your PATH."


# Define the path to your current i3 config file
I3_CONFIG="$HOME/.config/i3/config"

# Define the path to your custom config file (assumed to be in the same directory as this script)
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CUSTOM_CONFIG="$SCRIPT_DIR/config.txt"

# Check if the custom config file exists
if [ ! -f "$CUSTOM_CONFIG" ]; then
    echo "Error: Custom config file not found: $CUSTOM_CONFIG"
    exit 1
fi

#Format the file
sed -i 's/\r$//' "$CUSTOM_CONFIG"

# Empty the existing i3 config file
> "$I3_CONFIG"

# Replace the contents of the i3 config file with the custom config
cat "$CUSTOM_CONFIG" > "$I3_CONFIG"

echo "i3 config updated successfully."

#NEOFETCH
# Define the actual username and home directory, even when running with sudo
REAL_USER=$(logname)
REAL_HOME=$(eval echo ~$REAL_USER)

# Define the path to your script's directory
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Define the path to the Neofetch config file
NEOFETCH_CONFIG="$REAL_HOME/.config/neofetch/config.conf"

# Define the path to your custom Neofetch config file
CUSTOM_CONFIG="$SCRIPT_DIR/config.conf"

# Check if the custom config file exists
if [ ! -f "$CUSTOM_CONFIG" ]; then
    echo "Error: Custom config file not found: $CUSTOM_CONFIG"
    exit 1
fi

# Format the custom config file to ensure Unix-style line breaks
sudo -u $REAL_USER sed -i 's/\r$//' "$CUSTOM_CONFIG"

# Create Neofetch config directory if it doesn't exist
sudo -u $REAL_USER mkdir -p "$(dirname "$NEOFETCH_CONFIG")"

# Replace the contents of the Neofetch config file with the custom config
sudo -u $REAL_USER cp "$CUSTOM_CONFIG" "$NEOFETCH_CONFIG"

echo "Neofetch config updated successfully."


# Define the path to your ASCII art file
ASCII_ART_FILE="$SCRIPT_DIR/ascii.txt"

# Check if the ASCII art file exists
if [ ! -f "$ASCII_ART_FILE" ]; then
    echo "Error: ASCII art file not found: $ASCII_ART_FILE"
    exit 1
fi

# Format the ASCII art file to ensure Unix-style line breaks
sudo -u $REAL_USER sed -i 's/\r$//' "$ASCII_ART_FILE"

# Verify that Neofetch is configured to use the custom ASCII art
# Assuming the configuration for ASCII art in Neofetch is 'image_source'
if ! sudo -u $REAL_USER grep -q "image_source=\"$ASCII_ART_FILE\"" "$NEOFETCH_CONFIG"; then
    echo "Updating Neofetch config to use custom ASCII art."
    sudo -u $REAL_USER echo "image_source=\"$ASCII_ART_FILE\"" >> "$NEOFETCH_CONFIG"
fi





# Update .bashrc to run Neofetch on new terminal sessions
BASHRC="$REAL_HOME/.bashrc"

# Check if Neofetch is already added to .bashrc, if not, append it
if ! sudo -u $REAL_USER grep -q "neofetch" "$BASHRC"; then
    sudo -u $REAL_USER echo "neofetch" >> "$BASHRC"
fi

echo "Neofetch will now run on every new terminal session."



# Update desktop database
echo "Updating desktop database..."
update-desktop-database "$LOCAL_DESKTOP_DIR"

# Reload i3
echo "Reloading i3..."
i3-msg reload
i3-msg restart

echo "Setup complete!"
