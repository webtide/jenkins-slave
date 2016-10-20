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
               git && \
    apt-get -q autoremove && \
    apt-get -q clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/*.bin && \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

# SSHD Configuration

RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    systemctl enable ssh

RUN useradd -ms /bin/bash jetty
RUN echo 'jetty:jetty' | chpasswd

EXPOSE 22

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Jenkins Configuration

RUN mkdir /opt/jenkins && \
    echo "192.168.1.100 jenkins.webtide.net" >> /etc/hosts && \
    curl --insecure --output /opt/jenkins/slave.jar https://jenkins.webtide.net/jnlpJars/slave.jar
ADD slave.sh /opt/jenkins/

CMD [/bin/bash]

