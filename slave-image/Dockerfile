FROM ubuntu:24.04

MAINTAINER Olivier Lamy <olamy@apache.org>
ARG MAVEN_VERSION=3.9.9
ARG USER_HOME_DIR="/root"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

#non interactive
ENV DEBIAN_FRONTEND=noninteractive

# Packages Update / Install

USER root

RUN apt -q update  --fix-missing
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
                #leiningen \
                jq \
                nodejs \
                linux-lowlatency \            
                dnsutils \
                buildah \
                #podman \
                npm \
                rsync \
                #python3-pip \
                git

RUN    apt-get install -y --no-install-recommends ca-certificates fontconfig locales
RUN    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN    locale-gen en_US.UTF-8
RUN    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
       && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
       && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
       && apt update \
       && apt install gh -y
RUN    apt -q autoremove
RUN    apt -q clean -y
#RUN    rm -rf /var/lib/apt/lists/*
#RUN    rm -f /var/cache/apt/*.bin

# install launchable
#RUN pip install --upgrade launchable~=1.9

# too heavy
#COPY --from=eclipse-temurin:8u345-b01-jdk /opt/java/openjdk /opt/java/jdk8
#COPY --from=eclipse-temurin:11.0.16.1_1-jdk /opt/java/openjdk /opt/java/jdk11
#COPY --from=eclipse-temurin:17.0.4.1_1-jdk /opt/java/openjdk /opt/java/jdk17
#COPY --from=eclipse-temurin:21.0.5_11-jdk /opt/java/openjdk /opt/java/jdk21
COPY --from=eclipse-temurin:21 /opt/java/openjdk /opt/java/jdk21


ENV JAVA_HOME=/opt/java/jdk21
ENV PATH="${JAVA_HOME}/bin:${PATH}"

ARG BASE_URL=https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/${MAVEN_VERSION}

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
  && mkdir /home/jenkins \
  && mkdir /home/jenkins/agent

RUN cd /home/jenkins/ && git clone --mirror  https://github.com/jetty/jetty.project.git

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

ARG user=ubuntu
ARG group=ubuntu
ARG uid=1001
ARG gid=1001
#RUN addgroup -gid ${gid} ${group}
#RUN adduser --home /home/${user} --uid ${uid} --gid ${gid} ${user}
ARG AGENT_WORKDIR=/home/${user}/agent

RUN groupadd -r jetty && useradd -r -g jetty jetty

ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir -p /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}
VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

RUN chown -R ${user}:${user} /home/${user}
RUN mkdir -p /var/jenkins_home
RUN chown -R ${user}:${user} /var/jenkins_home
#ENV JAVA_HOME=/usr
ENV JAVA_HOME=/opt/java/jdk21
RUN echo 'unqualified-search-registries = ["docker.io"]' >> /etc/containers/registries.conf
USER ${user}
RUN curl -s "https://get.sdkman.io" | bash
RUN bash "$HOME/.sdkman/bin/sdkman-init.sh"
RUN mkdir -p ~/.sdkman/etc/
RUN echo "sdkman_auto_answer=true" > ~/.sdkman/etc/config
#RUN mkdir -p ~/.mimir/
#RUN echo "mimir.jgroups.interface=match-address\:192.168.1.*" > ~/.mimir/daemon.properties

#ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
#ENTRYPOINT ["/usr/local/bin/startSlave.sh"]


