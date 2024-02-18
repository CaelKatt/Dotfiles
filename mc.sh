#!/bin/bash

# Ensure the script is run as a normal user with sudo privileges
if [ "$(id -u)" -eq 0 ]; then
    echo "This script should not be run as root. Please run as a normal user with sudo privileges."
    exit 1
fi

# Update and install dependencies
echo "Updating system and installing dependencies..."
sudo apt update
sudo apt install -y git cmake g++ libssl-dev libcurl4-openssl-dev libudev-dev zlib1g-dev libpulse-dev libgmp-dev libx11-dev libx11-xcb-dev libxcb1-dev libxcomposite-dev libxi-dev libxtst-dev libgl1-mesa-dev libglu1-mesa-dev

# Additional dependencies based on common issues
sudo apt install -y libpng-dev libjpeg-dev

# Clone the mcpelauncher-ui repository
echo "Cloning the mcpelauncher-ui repository..."
git clone --recursive https://github.com/minecraft-linux/mcpelauncher-ui.git
cd mcpelauncher-ui
mkdir build
cd build

# Configure and build
echo "Configuring and building the launcher..."
cmake ..
make

# Install the launcher (optional step, requires user input)
echo "Do you wish to install the launcher globally? [y/N]"
read -r install_choice
if [[ $install_choice =~ ^[Yy]$ ]]; then
    echo "Installing the launcher globally..."
    sudo make install
else
    echo "Skipping global installation. You can run the launcher from the build directory."
fi

echo "Installation process complete."
echo "You can start Minecraft Bedrock Edition by navigating to the build directory and running ./mcpelauncher-ui-qt."
