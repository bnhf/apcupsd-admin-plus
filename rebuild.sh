#!/bin/bash

echo 'build new image';
docker build -t apcupsd-cgi .;
echo 'stop container'
docker stop apcupsd-cgi;
echo 'remove container'
docker rm apcupsd-cgi;
echo 'create and start new container'
echo 'docker run -d --name apcupsd-cgi -p 80 apcupsd-cgi';
docker run -d --name apcupsd-cgi -p 80 apcupsd-cgi;
docker port apcupsd-cgi
