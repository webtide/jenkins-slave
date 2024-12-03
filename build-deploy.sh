docker build --tag=jetty-build-agent:latest slave-image/

#to deploy
#timestamp format: 11-09-2023-16-31
export TS=`date +%d-%m-%Y-%H-%M`
docker tag jetty-build-agent:latest jettyproject/jetty-build-agent:$TS
docker push jettyproject/jetty-build-agent:$TS
echo jetty-build-agent:$TS
