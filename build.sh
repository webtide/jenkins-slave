#!/bin/bash

#not used anymore
#docker build --no-cache --tag=jenkins-slave:latest docker/

docker build --no-cache --tag=jetty-build:latest build-image/

#to deploy
# docker tag jetty-build:latest jettyproject/jetty-build:latest
# docker push jettyproject/jetty-build:latest

