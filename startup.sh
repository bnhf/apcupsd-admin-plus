#!/bin/bash

hostIp=$(/sbin/ip route|awk '/default/ { print $3 }');

sed -i "s/MONITOR 127.0.0.1/MONITOR $hostIp/g" /etc/apcupsd/hosts.conf
service fcgiwrap start;
