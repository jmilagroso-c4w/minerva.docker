# Dockerfile Reference https://docs.docker.com/engine/reference/builder/
# 
# Minerva Docker by Cloud4Wi DevOps Team


# Kafka and Zookeeper based image
FROM anapsix/alpine-java

# Cloud4wi Project Minerva (Docker Image)
# Created: 2017 January 26

# File Author / Maintainer
MAINTAINER Cloud4Wi DevOps Team

# ------------------- Apache Kafka and Zookeeper ------------------- 
# Prepare Apache Kafka and Zookeeper installation dependencies
RUN apk add --update unzip wget curl docker jq coreutils

# Define Kafka and Scala versions
ENV KAFKA_VERSION="0.10.1.0" SCALA_VERSION="2.11"
# Reference download script
ADD scripts/download-kafka.sh /tmp/download-kafka.sh
RUN chmod a+x /tmp/download-kafka.sh && sync && /tmp/download-kafka.sh && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka
ENV PATH ${PATH}:${KAFKA_HOME}/bin

COPY scripts/start-kafka.sh /usr/bin/start-kafka.sh
COPY scripts/broker-list.sh /usr/bin/broker-list.sh
COPY scripts/create-topics.sh /usr/bin/create-topics.sh
# The scripts need to have executable permission
RUN chmod a+x /usr/bin/start-kafka.sh && \
    chmod a+x /usr/bin/broker-list.sh && \
    chmod a+x /usr/bin/create-topics.sh

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]
# ------------------- Apache Kafka and Zookeeper -------------------


# ------------------- Apache Spark and Hadoop -------------------
#
FROM sequenceiq/hadoop-docker:2.6.0

# Support for Hadoop 2.6.0
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.6.1-bin-hadoop2.6.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-1.6.1-bin-hadoop2.6 spark
ENV SPARK_HOME /usr/local/spark
RUN mkdir $SPARK_HOME/yarn-remote-client
COPY configs/spark-core-site.xml $SPARK_HOME/yarn-remote-client/core-site.xml
COPY configs/spark-yarn-site.xml $SPARK_HOME/yarn-remote-client/yarn-site.xml

RUN $BOOTSTRAP && $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave && $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-1.6.1-bin-hadoop2.6/lib /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin
# update boot script
COPY scripts/spark-bootstrap.sh /etc/spark/bootstrap.sh
RUN chown root.root /etc/spark/bootstrap.sh
RUN chmod 700 /etc/spark/bootstrap.sh

# Install R (Do we need this?)
#RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#RUN yum -y install R

RUN export YARN_CONF_DIR="`pwd`/configs"

ENTRYPOINT ["/etc/spark/bootstrap.sh"]
# ------------------- Apache Spark and Hadoop -------------------

