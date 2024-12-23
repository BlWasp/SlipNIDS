#! /bin/bash

# System upgrade
sudo apt update
sudo apt dist-upgrade
sudo apt autoremove

echo "Start VPN installation and configuration"
echo "I recommend to use Wireguard with Cloudflare's DNS"
sleep 2

# VPN server installation
# I recommend Wireguard VPN with Cloudflare's DNS
curl -L https://install.pivpn.io | bash
echo "Type 'pivpn add' and 'pivpn -qr' to create a new Wireguard client, and display a QR code to configure it on a device"
sleep 2

echo "Start motion installation and configuration"
sleep 2

# Install and configure motion
sudo apt install motion
sudo apt install libcamera-v4l2

sudo sed -i 's/daemon off/daemon on/' /etc/motion/motion.conf
sudo sed -i 's/log_file \/var\/log\/motion\/motion.log/; log_file \/var\/log\/motion\/motion.log/' /etc/motion/motion.conf
sudo sed -i 's/width 640/width 1280/' /etc/motion/motion.conf
sudo sed -i 's/height 480/height 720/' /etc/motion/motion.conf
sudo sed -i 's/framerate 15/framerate 2/' /etc/motion/motion.conf
sudo sed -i 's/post_capture 0/post_capture 2/' /etc/motion/motion.conf
sudo sed -i 's/movie_max_time 60/movie_max_time 120/' /etc/motion/motion.conf
sudo sed -i 's/movie_codec mkv/movie_codec mp4/' /etc/motion/motion.conf
sudo sed -i 's/stream_localhost on/stream_localhost off/' /etc/motion/motion.conf

read -p "Enter your simplepush key: " simple_key
read -p "Enter the IP address of the Raspberry on the local network: " ip_address
sudo sed -i "s|; on_event_start value|on_event_start curl https://api.simplepush.io/send -d '{\"key\":\"$simple_key\", \"msg\":\"New detection : http://$ip_address:8081/\"}'|" /etc/motion/motion.conf

read -p "Enable authentication on the live stream ? [Y/N]" authentication
if [ "$authentication" = "Y" ]; then
    read -p "Indicate your username: " username
    read -p "Indicate your password: " password

    sudo bash -c 'echo "stream_auth_method 2" >> /etc/motion/motion.conf'
    echo "stream_authentication $username:$password" | sudo tee -a /etc/motion/motion.conf > /dev/null
fi

# Start motion with v4l2 device compatibility for Raspberry Pi
sudo libcamerify motion

read -p "Do you want to setup the Suricata IDS ? [Y/N]" suricata_setup
if [ "$suricata_setup" = "Y" ]; then
    echo "Start Suricata IDS installation and configuration"
    sleep 2

    chmod +x ./nids.sh
    ./nids.sh
fi
