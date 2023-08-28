#FROM jenkins/inbound-agent:latest-jdk11

FROM ubuntu:22.04

MAINTAINER Olivier Lamy <olamy@apache.org>
ARG MAVEN_VERSION=3.9.4
ARG USER_HOME_DIR="/root"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

#non interactive
ENV DEBIAN_FRONTEND=noninteractive

# Packages Update / Install

USER root

RUN apt -q update 
RUN apt -q upgrade -y
#RUN    apt -q install -y apt-utils
RUN    apt -q install -y \
                gcc      \
                zip      \
                wget     \
                unzip    \
                curl     \
                graphviz \
                make     \
                ca-certificates \
                gnupg-agent \
                gnupg \
                lsb-release \ 
                software-properties-common \
                iproute2 \
                leiningen \
                netcat \
                jq \
                netcat \
                nodejs \
                linux-lowlatency \            
                dnsutils \
                git
RUN    apt-get install -y --no-install-recommends ca-certificates fontconfig locales
RUN    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN    locale-gen en_US.UTF-8
RUN    apt -q autoremove
RUN    apt -q clean -y
#RUN    rm -rf /var/lib/apt/lists/*
#RUN    rm -f /var/cache/apt/*.bin

# too heavy
#COPY --from=eclipse-temurin:8u345-b01-jdk /opt/java/openjdk /opt/java/jdk8
#COPY --from=eclipse-temurin:11.0.16.1_1-jdk /opt/java/openjdk /opt/java/jdk11
#COPY --from=eclipse-temurin:17.0.4.1_1-jdk /opt/java/openjdk /opt/java/jdk17
#COPY --from=eclipse-temurin:19_36-jdk /opt/java/openjdk /opt/java/jdk19

#ENV JAVA_HOME=/opt/java/jdk11
#ENV PATH="${JAVA_HOME}/bin:${PATH}"

ARG BASE_URL=https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/${MAVEN_VERSION}

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
  && mkdir /home/jenkins \
  && mkdir /home/jenkins/agent

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
RUN addgroup -gid ${gid} ${group}
RUN adduser --home /home/${user} --uid ${uid} --gid ${gid} ${user}
ARG AGENT_WORKDIR=/home/${user}/agent


ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}
VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

RUN cd /home/jenkins/ && git clone --mirror  https://github.com/eclipse/jetty.project.git

COPY --from=jenkins/inbound-agent:latest-jdk11 /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-slave
COPY --from=jenkins/inbound-agent:latest-jdk11 /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar
COPY --from=jenkins/inbound-agent:latest-jdk11 /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent

COPY --from=gcr.io/kaniko-project/executor:v1.9.1 /kaniko /kaniko
RUN chmod +x /kaniko/executor

COPY --from=joyrex2001/kubedock:0.9.2 /app/kubedock /usr/local/bin/kubedock

RUN cd /usr/local/bin/ \
  && echo "#!/usr/bin/env sh" > startSlave.sh \
  && echo "kubedock server --lock --namespace=kubedock --timeout=10m0s --request-cpu=1 --request-memory=2Gi --port-forward &" >> startSlave.sh \
  && echo "/usr/local/bin/jenkins-agent" >> startSlave.sh \
  && chmod +x startSlave.sh

RUN chown -R jenkins:jenkins /home/jenkins
ENV JAVA_HOME=/usr

#ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
ENTRYPOINT ["/usr/local/bin/startSlave.sh"]


