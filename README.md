# apcupsd-cgi
Docker - APC UPS Power Management Web Interface (from nginx:latest, fcgiwrap, apcupsd-cgi)

*Requirements:*

This is the APC UPS Power Management Web Interface, so it is necessary to have an [APC UPS](https://www.apc.com/) that supports monitoring (USB cable or network). 
You have to install the [apcupsd daemon](http://www.apcupsd.org/) on the host machine(s). There are two options here, either install apcupsd directly on each host that has a UPS connected to it, or in a container on each of those hosts. If you have multiple UPS units, don't already have apcupsd installed on the host, and prefer to use Docker and Portainer when possible:

*Portainer Stacks (container-based) installation:*

```yml
version: '3.7'
services:
  apcupsd:
    image: gregewing/apcupsd:latest
    container_name: apcupsd
    devices:
      - /dev/usb/hiddev0 # Do an <ls /dev/usb> from the command line to determine possible options here
    ports:
      - 3551:3551
    environment:
      - TZ=${TZ}
    volumes:
      - /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket
      - /data/apcupsd:/etc/apcupsd # You'll need an apcupsd.conf file to exist in whatever folder on the host you're binding /etc/apcupsd to.
    restart: unless-stopped
```
*Environment variables required for the above (or hardcode values into compose):*

    TZ (The timezone you'd like apcupsd-cgi to use)

*For debian/ubuntu (host-based) installation:*

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

# apcupsd-cgi
The docker image is Debian 11 (Bullseye) based, with nginx-light as web server, fcgiwrap as cgi server and obviously apcupsd-cgi. 

Apcupsd-cgi is configured to search and connect to the apcupsd daemon on the host machine IP via the standard port 3551. Nginx is configured to connect with fcgiwrap (CGI server) and to serve multimon.cgi directly on port 80. The container exposes port 80, but can be remapped as required -- I use port 3552.

*Portainer Stacks (container-based) installation:*

```yml
version: '3.7'
services:
  apcupsd-cgi:
      image: bnhf/apcupsd-cgi:latest
      container_name: apcupsd-cgi
      ports:
        - 3552:80
      environment:
        - UPSHOSTS=${UPSHOSTS} # Ordered list of hostnames or IP addresses of UPS connected computers (space separated, no quotes)
        - UPSNAMES=${UPSNAMES} # Matching ordered list of location names to display on status page (space separated, no quotes)
        - TZ=${TZ} # Timezone to use for status page -- UTC is the default
      restart: unless-stopped
```
*Environment variables required for the above (or hardcode values into compose):*

    UPSHOSTS (List of hostnames or IP addresses for computers with connected APC UPSs. Space separated without quotes.)
    UPSNAMES (List of names you'd like used in the WebUI. Order must match UPSHOSTS. Space separated without quotes.)
    TZ (Timezone for apcupsd-cgi to use when displaying information about individual UPS units)
    
Here's an example of what your Portainer Stack would look like:
![screenshot-raspberrypi10_9000-2023 01 19-14_52_39](https://user-images.githubusercontent.com/41088895/213571158-ff25a8ec-e5f7-44d9-8588-754b5bd31226.png)

If you want to customize the image, you have to clone the repository on your system:
```
git clone https://github.com/bnhf/apcupsd-admin-plus.git
```
edit the files and recreate a new image
```
sudo docker build -t yourname/apcupsd-cgi .
```
## apcupsd-cgi
Enter the application at address http://your_host_IP:3552

Here's what it looks like running in an Organizr window with Portainer, Cockpit and OpenVPN Admin Plus available:

![screenshot-raspberrypi10-2023 01 19-14_49_21](https://user-images.githubusercontent.com/41088895/213570777-74d9dfb9-9c48-4de3-9129-16a6589a8d12.png)

And drilling down on one of the UPS units for additional detail:

![screenshot-raspberrypi10-2023 01 19-14_50_25](https://user-images.githubusercontent.com/41088895/213570880-d6eb5980-2f98-4523-a530-0fa0c3da7832.png)


