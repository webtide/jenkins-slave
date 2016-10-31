#!/bin/bash

docker run -it --rm \
     --dns=192.168.1.1 \
     --dns-search=phx.erdfelt.net \
     --volume /usr/bin/docker:/usr/bin/docker \
     --volume /var/run/docker.sock:/var/run/docker.sock \
     --volume /opt/shared:/opt/shared \
     jenkins-slave:latest \
     $@


