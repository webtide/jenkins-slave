FROM ubuntu:xenial
MAINTAINER Joakim Erdfelt <joakim@webtide.com>

# Packages Update / Install

RUN locale-gen en_US.UTF-8 && \
    apt-get -q update && \
    apt-get -q upgrade -y && \
    apt-get -q install -y \
               ca-certificates \
               openssh-server \
               openjdk-8-jdk-headless \
               curl \
               docker \
               dnsmasq \
               python \
               git && \
    apt-get -q autoremove && \
    apt-get -q clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/*.bin && \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

# SSHD Configuration

# RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
#    mkdir -p /var/run/sshd && \
#    systemctl enable ssh
# EXPOSE 22

# Setup DNS for internal network
RUN echo "10.0.0.11 jenkins.webtide.net" >> /etc/hosts

# Basic Locale Stuff

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Setup Jetty User

RUN useradd --create-home \
            --home-dir /opt/jenkins \
            --groups users \
            --shell /bin/bash \
            jetty
RUN echo 'jetty:jetty' | chpasswd

# Jenkins Configuration

RUN curl --insecure --output /opt/jenkins/slave.jar https://jenkins.webtide.net/jnlpJars/slave.jar
ADD slave.sh /opt/jenkins/

# Fix Permissions

RUN chown jetty:jetty /opt/jenkins/*

# Run as Jetty User

USER jetty
WORKDIR /opt/jenkins

CMD [/bin/bash]
