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
All is done, check the status of your UPS 
```
apcaccess status
```
