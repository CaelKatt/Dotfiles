#!/bin/bash

# Update and Upgrade the system
echo "Updating system package database..."
sudo apt update && sudo apt upgrade -y

# Install software-properties-common if not already installed (for add-apt-repository)
sudo apt install software-properties-common -y

# Add the graphics drivers PPA (Ubuntu and derivatives)
echo "Adding the graphics-drivers PPA..."
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update

# Install nvidia-detect (Debian and derivatives)
echo "Installing nvidia-detect..."
sudo apt install nvidia-detect -y

# Detect and recommend a driver
echo "Detecting recommended driver..."
recommended_driver=$(nvidia-detect | grep -oP 'nvidia-driver-\K\d+')
if [ -z "$recommended_driver" ]; then
    echo "No proprietary NVIDIA driver recommendation found. Exiting..."
    exit 1
else
    echo "Recommended driver: nvidia-driver-$recommended_driver"
fi

# Confirm with the user
read -p "Proceed with installing nvidia-driver-$recommended_driver? (y/n) " -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Remove any existing NVIDIA drivers first
    echo "Removing any existing NVIDIA drivers..."
    sudo apt purge '^nvidia-.*' -y

    # Install the recommended NVIDIA driver
    echo "Installing nvidia-driver-$recommended_driver..."
    sudo apt install "nvidia-driver-$recommended_driver" -y

    # Update the initramfs
    echo "Updating initramfs..."
    sudo update-initramfs -u

    echo "Installation complete. Please reboot your system."
else
    echo "Installation cancelled."
    exit 0
fi
