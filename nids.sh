#! /bin/bash

# Install Suricata IDS and update the rules
sudo apt install suricata
sudo suricata-update

# Configure Suricata's network monitoring
# By default it's : HOME_NET: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"
# You can change this HOME_NET variable in /etc/suricata/suricata.yaml to match with your network
# For example: HOME_NET: "[192.168.1.0/24]"

# Launch Suricata for test
# sudo suricata -c /etc/suricata/suricata.yaml -i eth0 -S /var/lib/suricata/rules/suricata.rules

# Enable Suricata as a service
sudo systemctl enable suricata

# Configure log rotation to avoid SD memory annihilation
sudo sed -i 's/rotate 14/rotate 10/' /etc/logrotate.d/suricata
sudo sed -i 's|/bin/kill -HUP $(cat /var/run/suricata.pid)|systemctl restart suricata.service|' /etc/logrotate.d/suricata
sudo sed -i '/rotate 10/a \\tmaxsize 1G' /etc/logrotate.d/suricata

# Auto-update the rules all nights
echo "37 1 * * * $(whoami) sudo suricata-update --disable-conf=/etc/suricata/disable.conf && sudo systemctl restart suricata.service" | sudo tee -a /etc/cron.d/suricata
