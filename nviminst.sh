#!/bin/bash

# Update and install dependencies
sudo apt-get update

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
