# My Debian Environment + i3 Configs

A repository featuring my Debian development environment and i3 configurations. This repo serves as a personal backup for my setup preferences and configurations. It's a collection of various config files and themes tailored for a Debian system with i3 window manager, primarily focused on a dark, black theme. While this is primarily for my own use, anyone interested in a similar setup is welcome to use and modify these configurations.

These instructions will guide myself/you through setting up a minimal Debian environment and configuring it with the contents of this repository.

### Prereqs

- A USB drive with Debian installer (light GUI version).
- Grab recent .iso from Debian site and use Rufus to deploy to USB.
https://debian.org/
https://rufus.ie/en/

### Installation

1. **Debian Installation:**
   - Start by installing a light version of Debian using the GUI installer from a USB drive.
   - Notable Settings:
     Choose "minimal installation" (only install standard system utilities).
     Do not set a root password (this will give your user sudo privileges).
   - Once booted and logged in, go ahead and `mkdir Downloads`, which is where CKD will be placed.
2. **Cloning the Repository:**
   - Once Debian is installed, open a terminal and install `git`:
     ```
     sudo apt-get update
     sudo apt-get upgrade
     sudo apt-get install git
     ```
   - Clone this repository:
     ```
     git clone https://github.com/CaelKatt/Dotfiles
     ```
   - Navigate to the cloned directory:
     ```
     cd Downloads/
     cd Dotfiles/
     ```

3. **Run the script**
   - Either run the master script, or alternatively any other script. Reccomended in some cases to first install i3 + gdm3 before running the script to be sure of installation.
     ```
     chmod +x setup.sh
     ./setup.sh
     ```

### Customization

Should one find oneself not with my specific specifications as I currently have, one may consider the alteration of the following:
   - i3 config display settings
   - packages list (which will be installed)
   - keybindings (once again inside the i3 config)
   - etc.
   - Be sure to apply settings in lxappearance.
   - Mullvad Inst Guide `https://mullvad.net/en/help/install-mullvad-app-linux`
---
Feel free to fork this repository and adapt the configurations to your liking. If you have improvements or suggestions, pull requests are welcome.
