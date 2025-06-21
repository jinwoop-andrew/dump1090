#!/bin/bash -e

# Build executables and cp it to /usr/local/bin
## dump1090
pushd /home/lg/dump1090

make
sudo cp dump1090 /usr/local/bin/

popd

## adsbhub.sh
sudo cp adsbhub.sh /usr/local/bin/

# Copy service files to systemd directory
sudo cp service_files/dump1090.service /etc/systemd/system/
sudo cp service_files/adsbhub.service /etc/systemd/system/

# Reload systemd configuration
sudo systemctl daemon-reload

# Enable services to start at boot
sudo systemctl enable dump1090.service
sudo systemctl enable adsbhub.service

# Start services manually (or reboot)
sudo systemctl start dump1090.service
sudo systemctl start adsbhub.service

# Check status
sudo systemctl status dump1090.service
sudo systemctl status adsbhub.service
