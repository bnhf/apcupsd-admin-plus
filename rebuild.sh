#!/bin/bash

docker build -t apcupsd-cgi .;
docker stop apcupsd-cgi;
docker rm apcupsd-cgi;
echo 'docker run -d --name apcupsd-cgi -p 80 apcupsd-cgi';
docker run -d --name apcupsd-cgi -p 80 apcupsd-cgi;
docker port apcupsd-cgi
