#!/bin/bash -e

# Build executables and cp it to /usr/local/bin
## dump1090
pushd /home/lg/dump1090

make
sudo cp dump1090 /usr/local/bin/

popd

## adsbhub.sh
sudo cp adsbhub.sh /usr/local/bin/

# Setup logrotate first
./logrotate.sh

# Copy service files to systemd directory
sudo cp service_files/dump1090.service /etc/systemd/system/
sudo cp service_files/adsbhub.service /etc/systemd/system/

# Reload systemd configuration
systemctl daemon-reload

# Enable services to start at boot
systemctl enable dump1090.service
systemctl enable adsbhub.service

# Start services manually (or reboot)
systemctl start dump1090.service
systemctl start adsbhub.service

# Check status
systemctl status dump1090.service
systemctl status adsbhub.service
