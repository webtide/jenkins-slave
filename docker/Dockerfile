FROM ubuntu:artful
MAINTAINER Joakim Erdfelt <joakim@webtide.com>

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Packages Update / Install

RUN apt-get -q update && \
    apt-get -q upgrade -y && \
    apt-get -q install -y \
               bzip2 \
               unzip \
               xz-utils \
               ca-certificates-java \
               openjdk-8-jdk-headless \
               curl \
               docker \
               dnsmasq \
               python \
               git && \
    apt-get -q autoremove && \
    apt-get -q clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/*.bin

# see CA_CERTIFICATES_JAVA_VERSION notes above
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Run as Jenkins User

ENV HOME /home/jenkins
RUN groupadd -g 10000 jenkins
RUN useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins

# Agent Install

ARG VERSION=3.16
ARG AGENT_WORKDIR=/home/jenkins/agent

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

# Environment Setup

USER jenkins
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/jenkins/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/jenkins/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/jenkins

# JNLP Setup

COPY jenkins-slave /usr/local/bin/jenkins-slave
ENTRYPOINT ["jenkins-slave"]
