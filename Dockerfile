FROM centos

MAINTAINER Zheng Li <me@zheng.io>

RUN yum install -y curl tar java-1.7.0-openjdk postgresql postgresql-server 
RUN yum clean all

RUN sed -i 's/test x/#test x/g' /etc/init.d/postgresql
RUN sed -i 's/ident/trust/g' /var/lib/pgsql/data/pg_hba.conf

# Postgresql
RUN service postgresql initdb
RUN service postgresql start
RUN RUN createuser -Upostgres --createdb --no-createrole --no-password --no-superuser dspace
RUN createdb -U dspace -E UNICODE dspace

# Tomcat
RUN curl http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz | tar xz -C /var/tomcat
ENV CATALINA_HOME=/var/tomcat

# Maven
RUN curl http://archive.apache.org/dist/maven/maven-2/2.2.1/binaries/apache-maven-2.2.1-bin.tar.gz | tar xz -C /etc/maven
ENV MAVEN_HOME=/etc/maven

# Ant
RUN curl http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.3-bin.tar.gz | tar xz -C /etc/ant
ENV MAVEN_HOME=/etc/ant