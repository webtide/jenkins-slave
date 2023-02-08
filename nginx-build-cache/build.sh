#!/bin/bash


#docker build --no-cache --tag=jetty-nginx-build-cache:latest .

docker build --tag=jetty-nginx-build-cache:latest .

docker build --no-cache --tag=jetty-nginx-build-cache:latest .

#to deploy

docker tag jetty-nginx-build-cache:latest  jettyproject/jetty-nginx-build-cache:$timestamp
docker push jettyproject/jetty-nginx-build-cache::$timestamp
