
FROM jenkins/jenkins:lts
MAINTAINER bogdan.suciu@yopeso.com

#Set number of executors
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

#Install default plugins and mark Jenkins as fully configured
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# Add the docker group and make jenkins a member so it can run docker inside containers
USER root
RUN groupadd -g 497 docker && groupadd -g 999 dockerkubernetes \
    gpasswd -a jenkins docker &&  gpasswd -a jenkins dockerkubernetes

RUN apt-get update && apt-get install -y libltdl7 && apt-get clean all

USER jenkins
