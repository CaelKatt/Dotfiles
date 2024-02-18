#!/bin/bash

# Define function to add non-free repositories for Debian
add_debian_non_free_repo() {
    echo "Adding non-free repository to sources.list..."
    sudo sed -i '/^deb/s/$/ contrib non-free/' /etc/apt/sources.list
    sudo apt update
}

# Ensure software-properties-common is installed (for add-apt-repository command availability)
echo "Ensuring software-properties-common is installed..."
sudo apt install software-properties-common -y

# Automatically identify the distribution ID (Debian, Ubuntu, etc.)
. /etc/os-release

# Add non-free repositories for Debian
if [ "$ID" = "debian" ]; then
    add_debian_non_free_repo
elif [ "$ID" = "ubuntu" ]; then
    echo "For Ubuntu, the script assumes the NVIDIA PPA is already added. If not, please add it manually."
else
    echo "This script is intended for Debian and Ubuntu systems only."
    exit 1
fi

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install the nvidia-detect tool (Debian-specific)
echo "Installing nvidia-detect to identify the best driver version..."
sudo apt install nvidia-detect -y

# Use nvidia-detect to recommend and install the best driver
recommended_driver=$(nvidia-detect | grep -o 'nvidia-driver')
if [ -z "$recommended_driver" ]; then
    echo "No specific NVIDIA driver recommendation found. Attempting to install the default nvidia-driver package."
    recommended_driver="nvidia-driver"
fi

echo "Recommended driver: $recommended_driver"
echo "Installing $recommended_driver..."

# Remove any existing NVIDIA drivers
echo "Removing any existing NVIDIA drivers..."
sudo apt purge '^nvidia-.*' -y

# Install the recommended NVIDIA driver
sudo apt install "$recommended_driver" -y

# Update the initramfs
echo "Updating initramfs..."
sudo update-initramfs -u

echo "NVIDIA driver installation complete. Please reboot your system."
