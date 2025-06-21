#!/bin/bash

# Check status
sudo systemctl status dump1090.service
sudo systemctl status adsbhub.service

# Stop services manually
sudo systemctl stop dump1090.service
sudo systemctl stop adsbhub.service

# Disable services to start at boot
sudo systemctl disable dump1090.service
sudo systemctl disable adsbhub.service

# Remove service files from systemd directory
sudo rm /etc/systemd/system/dump1090.service
sudo rm /etc/systemd/system/adsbhub.service

# Reload systemd configuration
sudo systemctl daemon-reload

# Remove executables
sudo rm /usr/local/bin/adsbhub.sh
sudo rm /usr/local/bin/dump1090
