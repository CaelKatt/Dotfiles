#!/bin/bash

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen git

# Clone the Neovim repository
git clone https://github.com/neovim/neovim

# Change directory to neovim
cd neovim

# Build Neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo

# Install Neovim
sudo make install

# Verify Neovim installation
nvim --version

echo "Neovim installation completed successfully."
