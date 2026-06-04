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

# provision Grafana dashboard data directories and files if requested
if [[ $DASHBOARD_PROVISION == "true" ]]; then
  mkdir -p /etc/grafana/provisioning/datasources/ /etc/grafana/provisioning/dashboards/ /etc/telegraf/ \
  && mv -v /opt/telegraf.conf /etc/telegraf \
  && mv -v /opt/datasource.yml /etc/grafana/provisioning/datasources \
  && mv -v /opt/dashboard.yml /etc/grafana/provisioning/dashboards \
  && mv -v /opt/APC-UPS-Detailed-Summary-1675087806267.json /etc/grafana/provisioning/dashboards
fi
        
# print host IP
# hostIp=$(/sbin/ip route|awk '/default/ { print $3 }')

# change the IP to monitor with the host IP in /etc/apcupsd/hosts.conf
# sed -i 's/MONITOR 127.0.0.1/MONITOR \"$hostIp\"/g' /etc/apcupsd/hosts.conf

# create nginx fastcgi cache directory
mkdir -p /tmp/nginx_cache

# start fcgiwrap directly (init.d not reliable in containers)
fcgiwrap -s unix:/var/run/fcgiwrap.socket &
sleep 1
chmod 777 /var/run/fcgiwrap.socket
nginx -g 'daemon off;'
