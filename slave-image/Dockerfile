FROM jenkins/jnlp-slave:latest-jdk11
ARG user=jenkins
USER ${user}
RUN cd /home/${user}/ && git clone --mirror  https://github.com/eclipse/jetty.project.git
