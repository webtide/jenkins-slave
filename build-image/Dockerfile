FROM ubuntu:20.04
MAINTAINER Olivier Lamy <olamy@apache.org>
ARG MAVEN_VERSION=3.8.6
ARG USER_HOME_DIR="/root"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

#non interactive
ENV DEBIAN_FRONTEND=noninteractive 

# Packages Update / Install

RUN apt -q update &&     \
    apt -q upgrade -y && \
    apt -q install -y    \
                gcc      \
                zip      \
                wget     \
                unzip    \
                curl     \
                python   \
                python3-pip \
                graphviz \
                make     \
                apt-transport-https \
                ca-certificates \
                gnupg-agent \
                software-properties-common \
                iproute2 \
                leiningen \
                netcat \
                jq \
                netcat \
                nodejs \
                dnsutils \
                git &&   \
    apt-get install -y --no-install-recommends curl ca-certificates fontconfig locales && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    apt -q autoremove && \
    apt -q clean -y &&   \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/*.bin

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

RUN apt -q update &&            \
    apt -q install -y           \
                docker-ce       \
                docker-ce-cli   \
                containerd.io


ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:11-jdk $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"

COPY --from=eclipse-temurin:8-jdk /opt/java/openjdk /opt/java/jdk8
COPY --from=eclipse-temurin:17-jdk /opt/java/openjdk /opt/java/jdk17
COPY --from=eclipse-temurin:19-jdk /opt/java/openjdk /opt/java/jdk19

ARG BASE_URL=https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/${MAVEN_VERSION}

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
  && mkdir /home/jenkins \
  && mkdir /home/jenkins/agent

RUN pip3 install --user --upgrade launchable~=1.0
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
RUN addgroup -gid ${gid} ${group}
RUN adduser --home /home/${user} --uid ${uid} --gid ${gid} ${user}
ARG AGENT_WORKDIR=/home/${user}/agent
RUN chown -R jenkins:jenkins /home/jenkins
RUN chown -R jenkins:jenkins /home/jenkins/agent
USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}
#ENV PATH=/home/jenkins/google-cloud-sdk/bin:$PATH
VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

