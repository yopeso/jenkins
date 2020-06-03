
FROM jenkins/jenkins:2.222.4
MAINTAINER bogdan.suciu@yopeso.com
USER root
#Set number of executors
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

#Install default plugins and mark Jenkins as fully configured
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /tmp/plugins.txt

# Disable installation of plugins during setup wizard
COPY disable-plugin-install-wizard.groovy /usr/share/jenkins/ref/init.groovy.d/

# Add the docker group and make jenkins a member so it can run docker inside containers
RUN groupadd -g 497 docker && groupadd -g 999 dockerkubernetes && \
    gpasswd -a jenkins docker &&  gpasswd -a jenkins dockerkubernetes

RUN apt-get update && apt-get install -y libltdl7 gettext && apt-get clean all

USER jenkins
