#! /bin/sh

echo "Update the system"
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y

echo "Install Suricata"
sudo apt install suricata -y
sudo update-rc.d suricata enable
sudo wget https://raw.githubusercontent.com/yeknu/emerging_updater/master/emergingupdater.py -O /etc/suricata/emergingupdater.py
echo "Auto-update the rules"
sudo python /etc/suricata/emergingupdater.py
#crontab -e
#TODO modifier crontab

echo "Install the utilities"
echo "Git"
sudo apt install git
echo "NodeJS"
sudo apt install nodejs
echo "npm"
sudo apt install npm
sudo npm i npm@latest -g
echo "Golang"
wget https://dl.google.com/go/go1.13.6.linux-armv6l.tar.gz
sudo tar -C /usr/local -xzf go1.13.6.linux-armv6l.tar.gz
export PATH=$PATH:/usr/local/go/bin

echo "Download Evebox"
git clone https://github.com/jasonish/evebox.git
cd evebox
echo "Compile dependencies"
make install-deps
cd webapp/
sed -i 's/.*"optimization": true,.*/              "optimization": false,/g' angular.json
cd ..
echo "Compile the project"
make
cp agent.yaml.example agent.yaml

echo "Install Nginx"
sudo apt install nginx-full
sudo cp sonde.eve /etc/nginx/sites-available
sudo ln -s /etc/nginx/sites-available/sonde.eve /etc/nginx/sites-enabled/sonde.eve
