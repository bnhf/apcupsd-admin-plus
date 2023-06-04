# APC UPS Power Management Web Interface (from debian:latest, fcgiwrap, apcupsd-cgi)
# FROM debian:buster
FROM debian:latest
LABEL Scott Ueland (https://github.com/bnhf)

# update
RUN apt-get -y update && apt-get -y upgrade
 
# install
RUN apt-get -y install nginx-light apcupsd-cgi fcgiwrap \
 && mkdir /opt/apcupsd \
 && mv /etc/apcupsd/* /opt/apcupsd

#ADD apcupsd-hosts.conf /etc/apcupsd/hosts.conf
COPY scripts /opt/apcupsd
COPY startup.sh /opt/startup.sh
COPY nginx.conf /etc/nginx/nginx.conf

# place files for optional dashboard provisioning
ADD dashboard/APC-UPS-Detailed-Summary-1675087806267.json \
    dashboard/dashboard.yml \
    dashboard/datasource.yml \
    dashboard/telegraf.conf /opt/

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

# clean
RUN apt-get clean

# Port
EXPOSE 80

CMD /opt/startup.sh
