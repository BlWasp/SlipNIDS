#! /bin/bash

sudo apt install libpcre3 libpcre3-dbg libpcre3-dev build-essential libpcap-dev libyaml-0-2 libyaml-dev pkg-config zlib1g zlib1g-dev make libmagic-dev libjansson-dev rustc cargo python-yaml python3-yaml liblua5.1-dev

#Get the source
wget https://www.openinfosecfoundation.org/download/suricata-6.0.2.tar.gz
tar -xvf suricata-6.0.2.tar.gz

#Configure installation
cd suricata-6.0.2
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --enable-nfqueue --enable-lua

#Compile and install it
make
sudo make install

#Compile and install Suricata update
cd suricata-update/
sudo python setup.py build
sudo python setup.py install

#Install it with the rules
cd ..
sudo make install-full
sudo suricata-update

#Configure Suricata's network monitoring
#By default it's : HOME_NET: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"
#You can change this HOME_NET variable in /etc/suricata/suricata.yaml to match with your network
#For example: HOME_NET: "[192.168.1.0/24]"

#Launch Suricata for test
#sudo suricata -c /etc/suricata/suricata.yaml -i eth0 -S /var/lib/suricata/rules/suricata.rules

#Configure to use Suricata as a service
echo "W1VuaXRdCkRlc2NyaXB0aW9uPVN1cmljYXRhIEludHJ1c2lvbiBEZXRlY3Rpb24gU2VydmljZQpBZnRlcj1uZXR3b3JrLnRhcmdldCBzeXNsb2cudGFyZ2V0CltTZXJ2aWNlXQpFeGVjU3RhcnQ9L3Vzci9iaW4vc3VyaWNhdGEgLWMgL2V0Yy9zdXJpY2F0YS9zdXJpY2F0YS55YW1sIC1pIGV0aDAgLVMgL3Zhci9saWIvc3VyaWNhdGEvcnVsZXMvc3VyaWNhdGEucnVsZXMKRXhlY1JlbG9hZD0vYmluL2tpbGwgLUhVUCAkTUFJTlBJRApFeGVjU3RvcD0vYmluL2tpbGwgJE1BSU5QSUQKW0luc3RhbGxdCldhbnRlZEJ5PW11bHRpLXVzZXIudGFyZ2V0" |base64 -d | sudo tee -a /etc/systemd/system/suricata.service

#Enable it
sudo systemctl enable suricata.service
#Now Suricata can be use with the systemctl command (stop, stat, restart, status)

#Configure log rotation to avoid SD memory annihilation
echo "L3Zhci9sb2cvc3VyaWNhdGEvKi5sb2cgL3Zhci9sb2cvc3VyaWNhdGEvKi5qc29uCnsKICAgIGRhaWx5CiAgICBtYXhzaXplIDFHCiAgICByb3RhdGUgMTAKICAgIG1pc3NpbmdvawogICAgbm9jb21wcmVzcwogICAgY3JlYXRlCiAgICBzaGFyZWRzY3JpcHRzCiAgICBwb3N0cm90YXRlCiAgICBzeXN0ZW1jdGwgcmVzdGFydCBzdXJpY2F0YS5zZXJ2aWNlCiAgICBlbmRzY3JpcHQKfQ==" |base64 -d | sudo tee -a /etc/logrotate.d/suricata

#Auto-update the rules all nights
echo "37 1 * * * $(whoami) sudo suricata-update --disable-conf=/etc/suricata/disable.conf && sudo systemctl restart suricata.service" | sudo tee -a /etc/cron.d/suricata