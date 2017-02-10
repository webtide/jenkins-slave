#!/bin/bash

docker run -it --rm \
     --dns=10.0.0.1 \
     --dns-search=piratecode.org \
     --volume /usr/bin/docker:/usr/bin/docker \
     --volume /var/run/docker.sock:/var/run/docker.sock \
     --volume /opt/shared:/opt/shared \
     jenkins-slave:latest \
     $@


