#!/bin/bash

# Verify running as a regular user, not root
if [ "$EUID" -eq 0 ]; then
    echo "This script must not be run as root. Please run as your regular user."
    exit
fi

# Install necessary packages (some commands need sudo)
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git gdm3 i3 i3blocks i3lock lxappearance materia-gtk-theme feh mc alacritty neovim xz-utils thunar neofetch gedit pulseaudio flatpak

#FLATPAKZ
# Install GNOME Software plugin for Flatpak
sudo apt install -y gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Define the path to the list of Flatpak apps to install
flatpak_list="flatpaks.txt"

# Check if the file exists
if [ ! -f "$flatpak_list" ]; then
    echo "File not found: $flatpak_list"
    exit 1
fi

# Function to check if a Flatpak app is installed
is_flatpak_installed() {
    flatpak list | grep -q "$1"
}

# Function to create wrapper script for each Flatpak app
create_wrapper_script() {
    local app_id="$1"
    local app_name=$(echo "$app_id" | awk -F '.' '{print tolower($NF)}')
    local script_path="$bin_dir/$app_name"

    # Check if bin_dir exists and is writable
    if [ ! -d "$bin_dir" ] || [ ! -w "$bin_dir" ]; then
        echo "Error: '$bin_dir' does not exist or is not writable"
        exit 1
    fi

    # Create the script content
    script_content="#!/bin/bash\nflatpak run $app_id"

    # Write the script content to the file, set execute permissions
    echo -e "$script_content" > "$script_path"
    chmod +x "$script_path" || { echo "Error setting execute permission on $script_path"; exit 1; }
}

# Install or update Flatpak apps from the list and create wrappers
while IFS= read -r line || [[ -n "$line" ]]; do
    if ! is_flatpak_installed "$line"; then
        echo "Installing Flatpak app: $line"
        flatpak install -y flathub "$line"
    fi
    create_wrapper_script "$line"
done < "$flatpak_list"

# Update all installed Flatpaks
echo "Updating all installed Flatpaks..."
flatpak update -y

# Create wrapper scripts for all installed Flatpak apps
echo "Creating wrapper scripts for all installed Flatpak apps..."
installed_apps=$(flatpak list --app --columns=application)
for app_id in $installed_apps; do
    create_wrapper_script "$app_id"
done

echo "Flatpak wrappers created for all installed apps. Please ensure $bin_dir is in your PATH."


# I3 CFG 
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



#Nightshift

#!/bin/bash

# Check if cron is installed, if not, install it
if ! command -v cron >/dev/null 2>&1; then
    echo "cron not found, installing..."
    sudo apt-get install cron
fi

# Ensure cron service is running
sudo systemctl enable cron
sudo systemctl start cron

# Install Redshift
echo "Installing Redshift..."
sudo apt-get install -y redshift redshift-gtk

# Create Redshift configuration directory and file
CONFIG_DIR="$HOME/.config"
REDSHIFT_CONFIG="$CONFIG_DIR/redshift.conf"

echo "Creating Redshift configuration file..."

mkdir -p "$CONFIG_DIR"

# Write configuration settings
cat > "$REDSHIFT_CONFIG" << EOF
; Global settings for redshift
[redshift]
temp-day=5700
temp-night=3500
fade=1

; Replace with your latitude and longitude
[manual]
lat=40.7128  ; Example latitude (New York City)
lon=-74.0060 ; Example longitude (New York City)
EOF

# Setup Cron jobs for Redshift
echo "Setting up Cron jobs for Redshift..."

# Add cron jobs to crontab
(crontab -l 2>/dev/null; echo "0 20 * * * DISPLAY=:0 redshift") | crontab -
(crontab -l 2>/dev/null; echo "0 4 * * * pkill redshift") | crontab -

echo "Setup complete. Redshift will start at 8:00 PM and stop at 4:00 AM daily."
