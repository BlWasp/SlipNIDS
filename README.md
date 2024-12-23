# SLIP NIDS

This project is a solution to quickly setup a detection lab on a Raspberry Pi for your home.

First, it permits the detection of physical intrusions with a camera, and the ability to identify movements, record what is happening, and send notifications on a mobile.

Then, a second optional script allows to setup a Suricata IDS on the Raspberry Pi to monitor your network trafic and detect digital intrusions.

Finally, a third script normally permits to configure a fully functional SIEM with a web GUI. **However, this one must be refactored.**

I advise to have, at least, 1GO of ram (Pi 3B, 3B+, 4, etc).

## Softwares used

- **Motion** : the detection software is [Motion](https://github.com/Motion-Project/motion). With a camera plugged in the Raspberry Pi, it permits to detect movements in front of the camera, and trigger some actions like recording a short movie, sending notification, etc.
- **Simplepush** : it is an [Android app](https://simplepush.io/) that simply permits to receive push notifications. It is used to receive messages from Motion when a movement is detected.
- **Suricata** : the IDS system works with the well-known [Suricata project](https://suricata.io/). It is enabled as a service, and a cron is setup to update the rules every nights.
- **Wireguard** : a Wireguard VPN server is setup on the Raspberry Pi. It is useful to access the Raspberry Pi from the Internet and view the camera stream without exposing it publicly (for example, when an alert is triggered and you are not at home). The setup is performed through [PiVPN](https://www.pivpn.io/).
- **Evebox** : the embedded SIEM is [Evebox](https://evebox.org/). This is a lite SIEM which can works with ElasticSearch or, in our case, with a SQL database. This soft works with NodeJS, NPM and Golang.
- **Nginx** : in order to access to the web interface of the SIEM, this project works with a Nginx server to provide a proxy.

## Installation

Just clone the project and run `./setup.sh`. Everything *should work*.

After the setup, you can quickly configure a Wireguard client on any device by simply displaying and scanning a QR code. Run `pivpn add` and `pivpn -qr` to create a new Wireguard client and display a QR code to configure it on a mobile device.

To start Motion, run `sudo libcamerify motion` (v4l2 device compatibility is needed on Raspberry Pi).

You can configure the network to monitor with Suricata in the file `/etc/suricata/suricata.yaml`
By default it's : `HOME_NET: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"`
You can change this **HOME_NET** variable to match with your network
For example: `HOME_NET: "[192.168.1.0/24]"`

## TODO

- Rewrite the SIEM setup in `siem.sh`

## Disclaimers

This script is provided without any warranty or support. It is not a professional project, but only something to setup a home lab and start playing with detection.