# SLIP NIDS

This is a script to setup a little NIDS on a Raspberry Pi.
I advise to have, at least, 1GO of ram (Pi 3B, 3B+, 4, etc).


Software used
=============

- Suricata : the alert system works with Suricata. A Python script is downloaded to automatically upgrade the rules of Suricata

- Evebox : the embedded SIEM is Evebox. This is a lite SIEM which can works with ElasticSearch or, in our case, with a SQL database. This soft works with NodeJS, NPM and Golang. The link of the Evebox Project : https://evebox.org/

- Nginx : in order to access to the web interface of the SIEM, this project works with a Nginx server to provide a proxy.


TODO
----

- Automatically setup the crontab for the updater script
