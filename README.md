# SLIP NIDS

This project is a solution to quickly setup a NIDS with a SIEM on a Raspberry Pi with the script `siem.sh`.
I advise to have, at least, 1GO of ram (Pi 3B, 3B+, 4, etc).

Alternatively, the script `nids.sh` permits to only setup a Suricata NDIS on the Raspberry Pi, without the SIEM, from the source.

This script is provided without any warranty or support.

Software used
=============

- Suricata : the alert system works with Suricata. A Python script is downloaded to automatically upgrade the rules of Suricata

- Evebox : the embedded SIEM is Evebox. This is a lite SIEM which can works with ElasticSearch or, in our case, with a SQL database. This soft works with NodeJS, NPM and Golang. The link of the Evebox Project : https://evebox.org/

- Nginx : in order to access to the web interface of the SIEM, this project works with a Nginx server to provide a proxy.

Installation
============

In your home directory, just run one of the script with `./script.sh`, and everything should work.

You can configure the network to monitor with Suricata in the file `/etc/suricata/suricata.yaml`
By default it's : `HOME_NET: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"`
You can change this **HOME_NET** variable to match with your network
For example: `HOME_NET: "[192.168.1.0/24]"`

TODO
----

- Automatically setup the crontab for the updater script in `siem.sh`
