FROM ubuntu:xenial
MAINTAINER Joakim Erdfelt <joakim@webtide.com>

RUN locale-gen en_US.UTF-8 && \
    apt-get -q update && \
    apt-get -q upgrade -y && \
    apt-get -q install -y openssh-server openjdk-8-jdk-headless && \
    apt-get -q autoremove && \
    apt-get -q clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/*.bin 

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "jenkins:jenkins" | chpasswd

# TODO: Install latest slave from master node?

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
