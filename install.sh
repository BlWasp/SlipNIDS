#!/bin/sh

echo "Mise à jour systeme"
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y

echo "Installation Suricata"
sudo apt install suricata -y
sudo update-rc.d suricata enable
sudo wget https://raw.githubusercontent.com/yeknu/emerging_updater/master/emergingupdater.py -O /etc/suricata/emergingupdater.py
echo "Mise a jour automatique des regles"
sudo python /etc/suricata/emergingupdater.py
#crontab -e
#TODO modifier crontab

echo "Installation des utilitaires"
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

echo "Telechargement Evebox"
git clone https://github.com/jasonish/evebox.git
cd evebox
echo "Compilation dependances"
make install-deps
cd webapp/
sed -i 's/.*"optimization": true,.*/              "optimization": false,/g' angular.json
cd ..
echo "Compilation projet"
make
cp agent.yaml.example agent.yaml

echo "Installation Nginx"
sudo apt install nginx-full
sudo cp sonde.eve /etc/nginx/sites-available
sudo ln -s /etc/nginx/sites-available/sonde.eve /etc/nginx/sites-enabled/sonde.eve
