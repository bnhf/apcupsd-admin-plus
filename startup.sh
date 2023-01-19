#!/bin/bash

rm /etc/apcupsd/apcupsd.conf && touch /etc/apcupsd/apcupsd.conf
array=( "$UPSHOSTS" )

for i in "${array[@]}"
    do 
        echo "MONITOR $i " >> /etc/apcupsd/apcupsd.conf
        
# print host IP
# hostIp=$(/sbin/ip route|awk '/default/ { print $3 }')

# change the IP to monitor with the host IP in /etc/apcupsd/hosts.conf
# sed -i 's/MONITOR 127.0.0.1/MONITOR \"$hostIp\"/g' /etc/apcupsd/hosts.conf

# start fcgiwarap
/etc/init.d/fcgiwrap start
nginx -g 'daemon off;'

