#!/bin/bash

SLAVEID=$1
SLAVESECRET=$2

cd /opt/jenkins

java -jar slave.jar \
   -noCertificateCheck \
   -jnlpUrl https://ci-master/computer/${SLAVEID}/slave-agent.jnlp \
   -secret ${SLAVESECRET}
