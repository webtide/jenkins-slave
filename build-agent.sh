#!/bin/bash

#not used anymore
#docker build --no-cache --tag=jenkins-slave:latest docker/

docker build --no-cache --tag=jetty-build-agent:latest slave-image/

#to deploy
# docker tag jetty-build-agent:latest jettyproject/jetty-build-agent:latest
# docker push jettyproject/jetty-build-agent:latest

