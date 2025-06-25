#!/bin/bash
# Setup logrotate configuration for dump1090 and adsbhub services

echo "Setting up logrotate for dump1090 and adsbhub services..."

# Create logrotate configuration for dump1090
sudo tee /etc/logrotate.d/dump1090 > /dev/null << 'EOF'
/var/log/dump1090.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    maxsize 100M
    create 644 root root
    postrotate
        systemctl reload-or-restart dump1090.service > /dev/null 2>&1 || true
    endscript
}
EOF

# Create logrotate configuration for adsbhub
sudo tee /etc/logrotate.d/adsbhub > /dev/null << 'EOF'
/var/log/adsbhub.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    maxsize 10M
    create 644 root root
    postrotate
        systemctl reload-or-restart adsbhub.service > /dev/null 2>&1 || true
    endscript
}
EOF

# Set proper permissions for logrotate configuration files
sudo chmod 644 /etc/logrotate.d/dump1090
sudo chmod 644 /etc/logrotate.d/adsbhub

# Test logrotate configurations
echo "Testing logrotate configurations..."

echo "Testing dump1090 logrotate config:"
sudo logrotate -d /etc/logrotate.d/dump1090

echo ""
echo "Testing adsbhub logrotate config:"
sudo logrotate -d /etc/logrotate.d/adsbhub

# Check if log files exist, create them if they don't
if [ ! -f /var/log/dump1090.log ]; then
    echo "Creating /var/log/dump1090.log..."
    sudo touch /var/log/dump1090.log
    sudo chmod 644 /var/log/dump1090.log
fi

if [ ! -f /var/log/adsbhub.log ]; then
    echo "Creating /var/log/adsbhub.log..."
    sudo touch /var/log/adsbhub.log
    sudo chmod 644 /var/log/adsbhub.log
fi

echo ""
echo "Logrotate setup complete!"
echo ""
echo "Configuration details:"
echo "  - Logs rotate daily"
echo "  - Keep 7 days of rotated logs"
echo "  - Compress old logs (except most recent)"
echo "  - Maximum log size: 10MB"
echo ""
echo "Configuration files created:"
echo "  - /etc/logrotate.d/dump1090"
echo "  - /etc/logrotate.d/adsbhub"
echo ""
echo "To manually test rotation:"
echo "  sudo logrotate -f /etc/logrotate.d/dump1090"
echo "  sudo logrotate -f /etc/logrotate.d/adsbhub"
