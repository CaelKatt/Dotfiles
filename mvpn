#!/bin/bash

# Ensure the script is run with sudo or by root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo privileges"
    exit 1
fi

# Update and install necessary packages
echo "Updating package index..."
apt update

echo "Installing necessary packages..."
apt install -y gnupg2 apt-transport-https

# Add the Mullvad repository
echo "Adding the Mullvad VPN repository..."
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
echo "deb https://repo.mullvad.net/deb/apt buster main" | tee /etc/apt/sources.list.d/mullvad-vpn.list

# Update package index with Mullvad repository
echo "Updating package index with Mullvad VPN repository..."
apt update

# Install Mullvad VPN
echo "Installing Mullvad VPN..."
apt install -y mullvad-vpn

echo "Mullvad VPN installation complete."

# Instructions to the user post-installation
echo "You can now run 'mullvad-vpn' to start the application."
echo "Use 'mullvad account set [your-account-number]' to set your account number."
echo "Use 'mullvad connect' to connect to the VPN."
