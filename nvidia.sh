#!/bin/bash

# Define a function to add non-free repositories for Debian
add_debian_non_free_repo() {
    echo "Adding non-free repository to sources.list for Debian..."
    sudo sed -i '/^deb/s/$/ contrib non-free/' /etc/apt/sources.list
    sudo apt update
}

# Define a function for Ubuntu to add the graphics drivers PPA
add_ubuntu_graphics_ppa() {
    echo "Adding the graphics-drivers PPA for Ubuntu..."
    sudo add-apt-repository ppa:graphics-drivers/ppa -y
    sudo apt update
}

# Install software-properties-common to enable add-apt-repository
echo "Ensuring software-properties-common is installed..."
sudo apt install software-properties-common -y

# Check if we are on Debian or Ubuntu and add repositories accordingly
. /etc/os-release
case "$ID" in
    debian)
        add_debian_non_free_repo
        ;;
    ubuntu)
        add_ubuntu_graphics_ppa
        ;;
    *)
        echo "This script is intended for Debian and Ubuntu systems."
        exit 1
        ;;
esac

# Prompt for manual driver selection
echo "Please visit https://www.nvidia.com/Download/index.aspx to find the recommended driver version for your GPU."
read -p "Enter the driver version you wish to install (e.g., nvidia-driver-460): " driver_version

# Validate input
if [[ -z "$driver_version" ]]; then
    echo "No driver version entered. Exiting..."
    exit 1
fi

# Remove any existing NVIDIA drivers
echo "Removing existing NVIDIA drivers..."
sudo apt purge '^nvidia-.*' -y

# Install the selected NVIDIA driver
echo "Installing $driver_version..."
sudo apt install "$driver_version" -y

# Update the initramfs
echo "Updating initramfs..."
sudo update-initramfs -u

echo "Driver installation complete. Please reboot your system."
