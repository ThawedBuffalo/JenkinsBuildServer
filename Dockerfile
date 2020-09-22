FROM jenkins/jenkins:lts
LABEL JC Reid <thawedbuffalo@gmail.com>
USER root

# set up args
ARG MAVEN_VERSION=3.6.3
ARG JAVA_VERSION=
ARG USER_HOME_DIR="/root"
#ARG SHA=b4880fb7a3d81edd190a029440cdf17f308621af68475a4fe976296e71ff4a4b546dd6d8a58aaafba334d309cc11e638c52808a4b0e818fc0fd544226d952544
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
    && echo "Downloading maven" \
    && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && echo "Unziping maven" \
    && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
    && echo "Cleaning and setting links" \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN mkdir -p /usr/share/java \
    && echo "Downloading java" \
    && curl -fsSL -o /tmp/java.jdk.tar.gz https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz \
    && echo "Unziping java" \
    && tar -xzf /tmp/java.jdk.tar.gz -C /usr/share/java --strip-components=1 \
    && echo "Cleaning and setting links" \
    #&& rm -f /tmp/java.jdk.tar.gz \
    #&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
    
    
    # set up Maven
#RUN apt-get install -y wget
#RUN wget --no-verbose -o /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-3.6.3-bin.tar.gz
#RUN mkdir -p /opt/maven
#RUN cp /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz /opt/maven
#RUN tar -xzf /opt/maven/apache-maven-${MAVEN_VERSION}-bin.tar.gz
#RUN ln -s /opt/maven/bin/mvn /usr/local/bin
#RUN ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven
#RUN rm -rf /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz
#ENV MAVEN_HOME /opt/maven
#ENV MAVEN_VERSION=${MAVEN_VERSION}
#ENV M2_HOME /usr/share/maven
#ENV maven.home $M2_HOME
#ENV M2 $M2_HOME/bin
#ENV PATH $M2:$PATH
#RUN chown -R jenkins:jenkins /opt/maven

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV PATH $M2:$PATH
ENV JAVA_HOME /usr/share/java
ENV PATH $JAVA_HOME:$PATH

# set up Java
#RUN apt-get install -y openjdk-11-jdk
#RUN wget --no-verbose -o /tmp/apache-maven-3.6.3-bin.tar.gz https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
#apt-get update && apt-get install -y wget unzip && \ wget download.java.net/java/GA/jdk11/13/GPL/… -O jdk.tar.gz -nv
#RUN apt-get clean



USER jenkins

# build docker
# docker build --tag "custom-jcreid-jenkins-java-maven" .
# run docker file wiht this command line
# docker run -u root --rm -d -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home custom-jcreid-jenkins-java-maven