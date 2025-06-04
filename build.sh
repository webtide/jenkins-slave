#!/bin/bash

#not used anymore
#docker build --no-cache --tag=jenkins-slave:latest docker/

#docker build --no-cache --tag=jetty-build:latest build-image/

docker build --no-cache --tag=jetty-build-agent:latest slave-image/
#docker build --tag=jetty-build-agent:latest slave-image/
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error"
    exit $retVal
fi

#to deploy
#timestamp format: 11-09-2023-16-31
export TS=`date +%d-%m-%Y-%H-%M`
docker tag jetty-build-agent:latest jettyproject/jetty-build-agent:$TS
docker push jettyproject/jetty-build-agent:$TS
echo $TS
