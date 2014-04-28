FROM centos

MAINTAINER Zheng Li <me@zheng.io>

RUN yum install -y curl tar java-1.7.0-openjdk postgresql postgresql-server 
RUN yum clean all

# Postgresql
RUN sed -i 's/test x/#test x/g' /etc/init.d/postgresql
RUN service postgresql initdb
RUN sed -i 's/ident/trust/g' /var/lib/pgsql/data/pg_hba.conf
RUN service postgresql start &&\
    createuser -Upostgres --createdb --no-createrole --no-password --no-superuser dspace &&\
    createdb -U dspace -E UNICODE dspace

# Tomcat
RUN curl http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz | tar xz
RUN mv apache-tomcat-7.0.53 /var/tomcat

# Maven
RUN curl http://archive.apache.org/dist/maven/maven-2/2.2.1/binaries/apache-maven-2.2.1-bin.tar.gz | tar xz
RUN mv apache-maven-2.2.1 /etc/maven

# Ant
RUN curl http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.3-bin.tar.gz | tar xz
RUN mv apache-ant-1.9.3 /etc/ant

# ENV
ENV JAVA_HOME /usr/lib/jvm/jre
ENV CATALINA_HOME /var/tomcat
ENV MAVEN_HOME /etc/maven
ENV ANT_HOME /etc/ant
ENV PATH $MAVEN_HOME/bin:$ANT_HOME/bin:$PATH

# DSpace
RUN curl http://downloads.sourceforge.net/project/dspace/DSpace%20Stable/4.1/dspace-4.1-release.tar.gz | tar xz
RUN mv dspace-4.1-release /dspace-source
RUN mvn -f /dspace-source/pom.xml package
RUN mv /dspace-source/dspace /dspace
RUN rm -rf /dspace-source
RUN ant -f /dspace-source/dspace/target/dspace-4.1.build/build.xml fresh_install