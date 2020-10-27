#!/bin/bash

#not used anymore
#docker build --no-cache --tag=jenkins-slave:latest docker/

docker build --no-cache --tag=jetty-build-18-04-jdk8:latest build-image/

#to deploy
# docker tag jetty-build-18-04-jdk8:latest jettyproject/jetty-build-18-04-jdk8:latest
# docker push jettyproject/jetty-build-18-04-jdk8:latest

