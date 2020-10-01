FROM jenkins/jenkins:lts
LABEL JC Reid <thawedbuffalo@gmail.com>
USER root

# set up args
ARG MAVEN_VERSION=3.6.3
ARG JAVA_VERSION=
ARG USER_HOME_DIR="/root"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN apt-get update && \
apt-get -y install apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
apt-get update && \
apt-get -y install docker-ce

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
    && echo "Downloading maven" \
    && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && echo "Unziping maven" \
    && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
    && echo "Cleaning and setting links" \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV M2_HOME /usr/share/maven
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH
RUN chown -R jenkins:jenkins /usr/share/maven

#
# NOTE: not able to install upgrade from java 8 jdk
#

# set up Java
#
#RUN apt-get update && apt-get install -y wget unzip && \ wget download.java.net/java/GA/jdk11/13/GPL/… -O jdk.tar.gz -nv
#RUN apt-get clean

USER jenkins

# build docker
# docker build --tag "custom-jcreid-jenkins-java-maven" .
# run docker file wiht this command line
# docker run -u root --rm -d -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home custom-jcreid-jenkins-java-maven