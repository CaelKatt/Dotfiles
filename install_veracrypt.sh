#!/bin/bash

# VeraCrypt Installer Script for Debian 12

# Define VeraCrypt download URL
# Note: Replace the URL with the latest version from https://www.veracrypt.fr/en/Downloads.html
VERACRYPT_URL="https://launchpad.net/veracrypt/trunk/1.26.7/+download/veracrypt-1.26.7-Debian-12-amd64.deb"

# Define the downloaded file name
VERACRYPT_DEB="veracrypt.deb"

echo "Downloading VeraCrypt..."
wget -O $VERACRYPT_DEB $VERACRYPT_URL

if [ -f "$VERACRYPT_DEB" ]; then
    echo "Installing VeraCrypt..."
    sudo dpkg -i $VERACRYPT_DEB

    # Fixing dependencies
    sudo apt-get -f install

    echo "VeraCrypt installed successfully."
else
    echo "Failed to download VeraCrypt."
    exit 1
fi

# Cleanup
echo "Cleaning up..."
rm $VERACRYPT_DEB

echo "Done."
