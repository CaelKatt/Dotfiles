#!/bin/bash

# Verify running as a regular user, not root
if [ "$EUID" -eq 0 ]; then
    echo "This script must not be run as root. Please run as your regular user."
    exit
fi

# Install necessary packages (some commands need sudo)
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git gdm3 i3 i3blocks i3lock lxappearance materia-gtk-theme tmux feh mc alacritty neovim xz-utils shutter thunar deluge neofetch gedit pulseaudio flatpak cmatrix ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip doxygen fzf

#VERACRYPT SPECIFICALLY
sudo apt install dirmngr ca-certificates software-properties-common gnupg gnupg2 apt-transport-https curl -y

curl -fsSL https://notesalexp.org/debian/alexp_key.asc | gpg --dearmor | sudo tee /usr/share/keyrings/alexp_key.gpg > /dev/null

echo 'deb [signed-by=/usr/share/keyrings/alexp_key.gpg] https://notesalexp.org/debian/bullseye/ bullseye main' | sudo tee -a /etc/apt/sources.list.d/alexp.list




#FLATPAKZ
# Install GNOME Software plugin for Flatpak
sudo apt install -y gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Function to install Flatpak apps from a .txt file
install_flatpaks_from_file() {
    local flatpak_list="$1"

    # Check if the file exists
    if [ ! -f "$flatpak_list" ]; then
        echo "File not found: $flatpak_list"
        return 1
    fi

    # Function to check if a Flatpak app is installed
    is_flatpak_installed() {
        flatpak list --app --columns=application | grep -q "^$1\$"
    }

    # Install or update Flatpak apps from the list
    while IFS= read -r line || [[ -n "$line" ]]; do
        if ! is_flatpak_installed "$line"; then
            echo "Installing Flatpak app: $line"
            flatpak install -y --noninteractive flathub "$line"
        else
            echo "Flatpak app already installed: $line"
        fi
    done < "$flatpak_list"
}

# Path to the .txt file with Flatpak app IDs
flatpak_list="flatpaks.txt"

# Install Flatpak apps from the file
install_flatpaks_from_file "$flatpak_list"

#WRAPPIN PAX
# Directory for wrapper scripts
bin_dir="$HOME/bin"

# Ensure the bin directory exists
mkdir -p "$bin_dir"

# Function to add bin_dir to PATH in .bashrc if it's not already there
add_to_path() {
    if ! grep -q "$bin_dir" "$HOME/.bashrc"; then
        echo "export PATH=\"\$PATH:$bin_dir\"" >> "$HOME/.bashrc"
        echo "Added $bin_dir to PATH in .bashrc. Please restart your shell or source .bashrc."
    else
        echo "$bin_dir is already in PATH."
    fi
}

# Function to create a wrapper script for a Flatpak app
create_wrapper_script() {
    local app_id="$1"
    local app_name=$(echo "$app_id" | awk -F '.' '{print tolower($NF)}')
    local script_path="$bin_dir/$app_name"

    # Create the script content
    echo -e "#!/bin/bash\nflatpak run $app_id" > "$script_path"

    # Set execute permissions
    chmod +x "$script_path"
}

# Add bin_dir to PATH
add_to_path

# Fetch list of installed Flatpak apps and create wrapper scripts
flatpak list --app --columns=application | while read -r app_id; do
    create_wrapper_script "$app_id"
done

echo "Wrapper scripts created for all installed Flatpak apps. Please ensure $bin_dir is in your PATH."

# Update all installed Flatpaks
echo "Updating all installed Flatpaks..."
flatpak update -y

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

# OTHER ADDITIONAL SCRIPTS
# Veracrypt inst
chmod +x install_veracrypt.sh
sudo ./install_veracrypt.sh\

#Nvim Inst
chmod +x nviminst.sh
./nviminst.sh

#Tmux inst
chmod +x tmux_setup.sh
./tmux_setup.sh

#Duplicate Flatpaks inst
chmod +x fpdupes.sh
./fpdupes.sh

#IMP FUZZY FINDING 
chmod +x fzf.sh
./fzf.sh
echo "Setup complete!"
