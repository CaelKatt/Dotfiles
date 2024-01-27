#!/bin/bash
#Nightshift

# Check if cron is installed, if not, install it
if ! command -v cron >/dev/null 2>&1; then
    echo "cron not found, installing..."
    sudo apt-get install cron
fi

# Ensure cron service is running
sudo systemctl enable cron
sudo systemctl start cron

# Install Redshift
echo "Installing Redshift..."
sudo apt-get install -y redshift redshift-gtk

# Create Redshift configuration directory and file
CONFIG_DIR="$HOME/.config"
REDSHIFT_CONFIG="$CONFIG_DIR/redshift.conf"

echo "Creating Redshift configuration file..."

mkdir -p "$CONFIG_DIR"

# Write configuration settings
cat > "$REDSHIFT_CONFIG" << EOF
; Global settings for redshift
[redshift]
temp-day=5700
temp-night=3500
fade=1

; Replace with your latitude and longitude
[manual]
lat=40.7128  ; Example latitude (New York City)
lon=-74.0060 ; Example longitude (New York City)
EOF

# Setup Cron jobs for Redshift
echo "Setting up Cron jobs for Redshift..."

# Add cron jobs to crontab
(crontab -l 2>/dev/null; echo "0 20 * * * DISPLAY=:0 redshift") | crontab -
(crontab -l 2>/dev/null; echo "0 4 * * * pkill redshift") | crontab -

echo "Setup complete. Redshift will start at 8:00 PM and stop at 4:00 AM daily."
