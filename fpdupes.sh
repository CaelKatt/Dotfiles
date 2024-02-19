#!/bin/bash

# INSTALLS MY DUPLICATE FLATPAKS

# Step 1: Define a new Flatpak installation named "flatpak-II"
flatpak_installation_name="flatpak-II"

# Step 2: Add Flathub to the new installation (if not already added)
flatpak --user remote-add --if-not-exists --installation=$flatpak_installation_name flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Step 3: Install the Flatpak application to the new installation
flatpak install --user --installation=$flatpak_installation_name flathub md.obsidian.Obsidian -y

# WRAPPIN' + II ID

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

# Function to create a wrapper script for a Flatpak app with a custom data folder
create_wrapper_script() {
    local app_id="$1"
    local app_name=$(echo "$app_id" | awk -F '.' '{print tolower($NF)}')"-II"
    local script_path="$bin_dir/$app_name"
    local custom_data_folder="$HOME/.local/share/flatpak-apps/$app_name"

    # Ensure the custom data folder exists
    mkdir -p "$custom_data_folder"

    # Create the script content with custom HOME directory and specify the custom installation
    echo -e "#!/bin/bash\nenv HOME=\"$custom_data_folder\" flatpak run --user --installation=$flatpak_installation_name $app_id" > "$script_path"

    # Set execute permissions
    chmod +x "$script_path"
}

# Add bin_dir to PATH
add_to_path

# Create a wrapper script for the installed app with a custom data folder
create_wrapper_script "md.obsidian.Obsidian"

echo "Wrapper script created for Obsidian with '-II' suffix. Please ensure $bin_dir is in your PATH."
