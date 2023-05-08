#!/bin/bash

# Check if /etc/apcupsd files exist, and copy them from /opt/apcupsd if they don't
files=( apcupsd.conf apccontrol changeme commfailure commok killpower multimon.conf offbattery onbattery ups-monitor apcupsd.css )

for i in "${files[@]}"
  do
    if [ ! -f /etc/apcupsd/$i ]; then
      cp /opt/apcupsd/$i /etc/apcupsd/$i \
      && echo "No existing $i found"
    else
      echo "Existing $i found, and will be used"
    fi
  done

# remove current, and create empty, hosts file
rm /etc/apcupsd/hosts.conf && touch /etc/apcupsd/hosts.conf

# populate two arrays with host and UPS names
HOSTS=( $UPSHOSTS )
NAMES=( $UPSNAMES )

# add monitors to hosts.conf for each host and UPS name combo
for ((i=0;i<${#HOSTS[@]};i++))
    do
        echo "MONITOR ${HOSTS[$i]} \"${NAMES[$i]}\"" >> /etc/apcupsd/hosts.conf
        echo "MONITOR ${HOSTS[$i]} \"${NAMES[$i]}\""
done
        
# print host IP
# hostIp=$(/sbin/ip route|awk '/default/ { print $3 }')

# change the IP to monitor with the host IP in /etc/apcupsd/hosts.conf
# sed -i 's/MONITOR 127.0.0.1/MONITOR \"$hostIp\"/g' /etc/apcupsd/hosts.conf

# start fcgiwarap
/etc/init.d/fcgiwrap start
nginx -g 'daemon off;'
