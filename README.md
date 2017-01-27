# Minerva Docker

Minerva Docker packages Big Data app with its dependencies, freeing you from worrying about your system configuration, and making your app more portable.

  - Apache Kafka
  - Apache Phoenix
  - Apache Spark
  - Apache Zookeeper 
  - Redis

##### Prerequisites

Docker Engine https://docs.docker.com/engine/installation/
Docker Compose https://docs.docker.com/compose/install/

##### References
Minerva uses a number of open source projects to work properly:

* [wurstmeister/kafka-dockerr] - Apache Kafka on Docker
* [sequenceiq/docker-spark]    - Apache Spark on Docker

##### Commands

Start Cluster (Detached mode with build option)
```sh
$ git clone git@github.com:jmilagroso-c4w/minerva.docker.git
$ cd minerva.docker
$ docker-compose up -d --build
```
Start Cluster (Detached mode)
```
$ docker-compose up -d
```

Add Kafka Brokers
```
$ docker-compose kafka=2
```

Checking services states:

```sh
$ docker-compose ps
```

Shutdown services:

```sh
$ docker-compose down
```

