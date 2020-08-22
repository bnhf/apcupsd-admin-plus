# apcupsd-cgi
Docker - APC UPS Power Management Web Interface (from nginx:latest, fcgiwrap, apcupsd-cgi)

# Requirements
This is the APC UPS Power Management Web Interface, so it is necessary to have an APC UPS that supports monitoring (USB cable or network). 
You have to install apcupsd daemon in the host machine (if the APC UPS is connected here). For debian/ubuntu:
```
sudo apt install apcupsd
```
If you have connected your APC UPS with a USB cable you can check that it is correctly detected:
```
sudo lsusb
```
You should find a device "American Power Conversion Uninterruptible Power Supply". Edit the file /etc/apcupsd/apcupsd.conf following the guide you find on the official website.
```
sudo nano /etc/apcupsd/apcupsd.conf
```
The minimum parameters to be configured in case of USB connection are the following:
| Parameter | Setting | Notes |
| :----: | --- | ---|
| UPSCABLE | usb | define the tyoe of cable connection |
| UPSTYPE | usb | define the type of UPS |
| DEVICE |  |leave blank for autoconfig usb port| 
| NETSERVER | on | enable network information server|
| NISIP | 0.0.0.0 | IP address on wich NIS server will listen for incoming connections|

Now edit /etc/default/apcupsd
```
sudo nano /etc/default/apcupsd
```
ISCONFIGURED=yes

All is done, check the status of daemon 
```
sudo systemctl status apcupsd
```
If the daemon is not running, proceed to enable and start it
```
sudo systemctl enable apcupsd && sudo systemctl start apcupsd
```
check the status of your APC UPS
```
apcaccess status
```

## Docker apcupsd-cgi
The docker image is Debian buster based, with nginx-light as web server, fcgiwrap as cgi server and obviously apcupsd-cgi. 

Apcupsd-cgi is configured to search and connect apcupsd daemon in the host machine IP on standard port 3551. Nginx is configured to conncet with fcgiwrap (CGI server) and to serve multimon.cgi directly on port 80. 
As explained the container exposes port 80, if as I think port 80 on your host is already busy, redirect it to a free port. I use port 4321. 

To run docker container:
```
docker run -d -p 4321:80 -restart=unless-stopped --name apcupsd-cgi zedred/apcupsd-cgi
```
If you use Docker compose
```
versione: "2.1"
services:
  apcupsd-cgi:
      image: zedred/apcupsd-cgi
      container_name: apcupsd-cgi
      restart: unless-stopped
      ports:
        - 4321:80
```

If you want to customize the image edit the files and recreate a new image

## Docker apcupsd-cgi
Enter the application at address http://you_host_IP:4321


