#!/bin/bash

# Check status
systemctl status adsbhub.service
systemctl status dump1090.service

# Stop services manually
systemctl stop adsbhub.service
systemctl stop dump1090.service

# Disable services to start at boot
systemctl disable adsbhub.service
systemctl disable dump1090.service

# Remove service files from systemd directory
sudo rm /etc/systemd/system/adsbhub.service
sudo rm /etc/systemd/system/dump1090.service

# Reload systemd configuration
systemctl daemon-reload

# Remove logrotate
sudo rm /etc/logrotate.d/adsbhub
sudo rm /etc/logrotate.d/dump1090

# Remove executables
sudo rm /usr/local/bin/adsbhub.sh
sudo rm /usr/local/bin/dump1090
