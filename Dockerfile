# APC UPS Power Management Web Interface (from debian:latest, fcgiwrap, apcupsd-cgi)
FROM debian:latest 
# FROM debian:jessie

# update
RUN apt-get -y update
 
# install
RUN apt-get -y install nginx-light apcupsd-cgi fcgiwrap
RUN update-rc.d fcgiwrap defaults

ADD startup.sh /
ADD nginx.conf /etc/nginx/nginx.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

# clean
RUN apt-get clean

# Port
EXPOSE 80

CMD /startup.sh; nginx -g 'daemon off;';
