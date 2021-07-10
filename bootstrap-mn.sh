#!/usr/bin/env bash
# Update the index
sudo apt-get -y update

# Install c libraries 
sudo apt-get -y install build-essential
# Install vi editor
sudo apt-get -y install vim
sudo apt-get -y install tree
sudo apt-get -y install net-tools
sudo apt-get -y install sshpass
sudo apt-get -y install unzip
sudo apt-get -y install curl

#Installing Python 3.7
sudo apt -y install software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt -y update
sudo apt -y install python3.7
echo " Python 3.7 installation complete "

#Adding Open JDK installer
sudo -E add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get -y update
sudo apt-get -y install openjdk-8-jdk
sudo update-ca-certificates -f


#sudo apt-get install lxde
#sudo apt-get install gedit


# Setup SSH
ssh-keygen -t rsa -P "" -f /home/vagrant/.ssh/id_rsa
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/known_hosts
curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub >>/home/vagrant/.ssh/authorized_keys

chmod 0600 /home/vagrant/.ssh/authorized_keys

# Verify ssh

ssh -o StrictHostKeyChecking=no vagrant@localhost 'sleep 5 && exit'
ssh -o StrictHostKeyChecking=no vagrant@master 'sleep 5 && exit'
ssh -o StrictHostKeyChecking=no vagrant@192.168.56.70 'sleep 5 && exit'
ssh -o StrictHostKeyChecking=no vagrant@0.0.0.0 'sleep 5 && exit'


echo "Installing MySQL Server"
echo "mysql-server mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | sudo debconf-set-selections
sudo apt-get -y install mysql-server mysql-client
echo " MySQL server  installed"

mysql -uroot -proot -e "CREATE DATABASE metastore_db;"
    mysql -uroot -proot -e "CREATE USER 'hiveuser'@'localhost' IDENTIFIED BY 'hivepassword';"
	mysql -uroot -proot -e "CREATE USER 'hiveuser'@'master' IDENTIFIED BY 'hivepassword';"
    mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'hiveuser'@'localhost' identified by 'hivepassword';"
	mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'hiveuser'@'master' identified by 'hivepassword';"
	mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'hiveuser'@'%' identified by 'hivepassword';"
	mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by 'root';"
    mysql -uroot -proot -e "FLUSH PRIVILEGES;"
echo " metastore_db @MySQL server  created"

#Host Name - IP Address resolution
cp /vagrant/hosts /home/vagrant
sudo chmod 777 /etc/hosts
cat /home/vagrant/hosts >/etc/hosts
sudo chmod 644 /etc/hosts


# Create directory to store the MongoDB document
sudo mkdir -p /data/db
sudo chown -R vagrant:vagrant /data

# Create directory to store the required software
mkdir -p /home/vagrant/bigdata
cd /home/vagrant/bigdata
pwd



# Create directories for spark-events
mkdir -p /home/vagrant/bigdata/spark-events
mkdir -p /home/vagrant/bigdata/spark_tmp/spark




# Download Spark pre-built with hadoop 2.7+
echo "Dowloading Spark"

wget -q https://archive.apache.org/dist/spark/spark-3.0.2/spark-3.0.2-bin-hadoop2.7.tgz

echo "Dowloading SBT"
wget -q https://github.com/sbt/sbt/releases/download/v1.2.0/sbt-1.2.0.tgz



# Download jdk binaries
echo "Dowloading Java"
wget -q --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz

# Download Scala binaries
echo "Dowloading Scala"
wget -q  https://downloads.lightbend.com/scala/2.12.2/scala-2.12.2.tgz


# Download Kafka binaries
echo "Dowloading Kafka"
wget -q https://archive.apache.org/dist/kafka/2.8.0/kafka_2.12-2.8.0.tgz



# Download Apache Cassandra
echo "Dowloading Cassandra"
wget -q http://archive.apache.org/dist/cassandra/3.11.10/apache-cassandra-3.11.10-bin.tar.gz

# Download MongoDB
echo "Dowloading MongoDB"
#wget -q https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-4.0.9.tgz
wget -q https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-4.2.13.tgz


# Download MySQL JDBC Driver
echo "Dowloading MySQL JDBC Driver"
wget -q https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz

# Download Confluent Community Edition
echo "Dowloading Confluent Community Edition 6.2.0 "
wget -q https://packages.confluent.io/archive/6.2/confluent-community-6.2.0.tar.gz


echo "Spark Extraction Started "
# Extract the Spark  binaries
tar -xf spark-3.0.2-bin-hadoop2.7.tgz
mv spark-3.0.2-bin-hadoop2.7 spark
rm spark-3.0.2-bin-hadoop2.7.tgz
echo "Spark Extraction Completed "

echo "Java Extraction Started "
# Extract java binaries
tar -xf jdk-8u131-linux-x64.tar.gz
mv jdk1.8.0_131 java
rm jdk-8u131-linux-x64.tar.gz
echo "Java Extraction Completed "


echo "Scala Extraction Started "
# Extract Scala binaries
tar -xf scala-2.12.2.tgz
mv scala-2.12.2 scala
rm scala-2.12.2.tgz
echo "Scala Extraction Completed "

echo "SBT Extraction Started "
#Extract sbt 
tar -xf sbt-1.2.0.tgz
rm  sbt-1.2.0.tgz
echo "SBT Extraction Completed "

echo "Kafka Extraction Started "
#Extract Kafka 

tar xf kafka_2.12-2.8.0.tgz
mv kafka_2.12-2.8.0 kafka
rm kafka_2.12-2.8.0.tgz
echo "Kafka Extraction Completed "

echo "Cassandra Extraction Started "
#Extract Cassandra 

tar xf apache-cassandra-3.11.10-bin.tar.gz
mv apache-cassandra-3.11.10 cassandra
rm apache-cassandra-3.11.10-bin.tar.gz
echo "Cassandra Extraction Completed "

echo "MongoDB Extraction Started "
#Extract MongoDB 
#tar xf mongodb-linux-x86_64-4.0.9.tgz
#mv mongodb-linux-x86_64-4.0.9 mongodb
#rm mongodb-linux-x86_64-4.0.9.tgz

tar xf mongodb-linux-x86_64-ubuntu1604-4.2.13.tgz
mv mongodb-linux-x86_64-ubuntu1604-4.2.13 mongodb
rm mongodb-linux-x86_64-ubuntu1604-4.2.13.tgz

echo "MongoDB Extraction Completed "

echo "MySQL JDBC Extraction Started "
#Extract MySQL JDBC Driver 
tar xf mysql-connector-java-5.1.47.tar.gz
mv mysql-connector-java-5.1.47 mysql-connector
rm mysql-connector-java-5.1.47.tar.gz
echo "MySQL JDBC Extraction Completed "

echo "Confluent Community Edition Extraction Started "
tar xf confluent-community-6.2.0.tar.gz
mv confluent-6.2.0 confluent
rm confluent-community-6.2.0.tar.gz
echo "Confluent Community Edition Extraction Completed "

echo "Downloading & Installing Confluent Hub "
cd /home/vagrant/bigdata/confluent/
wget -q http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz
tar xf confluent-hub-client-latest.tar.gz
rm confluent-hub-client-latest.tar.gz
cd /home/vagrant/bigdata/
echo "Download & Installation of Confluent Hub completed"

echo "Downloading & Installing Confluent CLI "
# curl -L --http1.1 https://cnfl.io/cli | sh -s -- -b $CONFLUENT_HOME/bin
cd /home/vagrant/
wget -q https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/latest/confluent_latest_linux_amd64.tar.gz
tar xf confluent_latest_linux_amd64.tar.gz
mv /home/vagrant/confluent/* /home/vagrant/bigdata/confluent/bin/
rm confluent_latest_linux_amd64.tar.gz
cd /home/vagrant/bigdata/
echo "Download & Installation of Confluent CLI completed"

echo " Configuring ENVIRONMENT Variables "
# set env variables in .bashrc file
echo 'export JAVA_HOME=/home/vagrant/bigdata/java' >> /home/vagrant/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /home/vagrant/.bashrc

echo 'export SCALA_HOME=/home/vagrant/bigdata/scala' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$SCALA_HOME/bin' >> /home/vagrant/.bashrc
echo 'export SPARK_HOME=/home/vagrant/bigdata/spark' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >> /home/vagrant/.bashrc
echo 'export SBT_HOME=/home/vagrant/bigdata/sbt' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$SBT_HOME/bin' >> /home/vagrant/.bashrc
echo 'export KAFKA_HOME=/home/vagrant/bigdata/kafka' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$KAFKA_HOME/bin' >> /home/vagrant/.bashrc

echo 'export CASSANDRA_HOME=/home/vagrant/bigdata/cassandra' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$CASSANDRA_HOME/bin' >> /home/vagrant/.bashrc

echo 'export MONGODB_HOME=/home/vagrant/bigdata/mongodb' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$MONGODB_HOME/bin' >> /home/vagrant/.bashrc

echo 'export CONFLUENT_HOME=/home/vagrant/bigdata/confluent' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$CONFLUENT_HOME/bin' >> /home/vagrant/.bashrc

echo 'export PYSPARK_PYTHON=python3.7'>>/home/vagrant/.bashrc

source /home/vagrant/.bashrc
source /home/vagrant/.bashrc
echo $JAVA_HOME

echo " Configuring ENVIRONMENT Variables Completed"

echo " Copying Configuration Files "

# copy hadoop configuraton files from host to the guest VM
#By default, Vagrant will share your project directory (the directory with the Vagrantfile) to /vagrant


# copy Spark configuraton files from host to the guest VM
cp /vagrant/slaves /home/vagrant/bigdata/spark/conf/
cp /vagrant/spark-env.sh /home/vagrant/bigdata/spark/conf/
cp /vagrant/spark-defaults.conf /home/vagrant/bigdata/spark/conf/
cp /vagrant/log4j.properties /home/vagrant/bigdata/spark/conf/

#Copy  MySQL JDBC Driver to Hive Directory
echo " Configuring JDBC Driver for Spark & Kafka "
cp /home/vagrant/bigdata/mysql-connector/mysql-connector-java-5.1.47.jar /home/vagrant/bigdata/spark/jars/
cp /home/vagrant/bigdata/mysql-connector/mysql-connector-java-5.1.47.jar /home/vagrant/bigdata/kafka/libs/
echo " Configuring JDBC Driver for Spark & Kafka complete"


echo " Configuring JDBC Driver for Confluent "
mkdir -p /home/vagrant/bigdata/confluent/share/java/kafka-connect-jdbc
cp /home/vagrant/bigdata/mysql-connector/*.jar /home/vagrant/bigdata/confluent/share/java/kafka-connect-jdbc/
wget -q https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.25.tar.gz
tar xf mysql-connector-java-8.0.25.tar.gz
cp mysql-connector-java-8.0.25/*.jar /home/vagrant/bigdata/confluent/share/java/kafka-connect-jdbc/
echo " Configuring JDBC Driver for Confluent complete"

sudo cp /vagrant/my.cnf /etc/mysql/my.cnf	

# copy dataset files from host to the guest VM   
cp  /vagrant/dataset.zip /home/vagrant/dataset.zip
cp  /vagrant/install-connectors.sh /home/vagrant/install-connectors.sh

echo " Copying Configuration Files Completed"

echo " Installing Confluent Kafka Connector "
echo " Installing Confluent Kafka Datagen Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:latest
echo " Installation Completed of  Confluent Kafka Datagen Connector "

echo " Installing Confluent Kafka JDBC Source/Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.2.0
echo " Installation Completed of  JDBC Source/Sink Connector "

echo " Installing Confluent Kafka HDFS3 Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-hdfs3:1.1.1
echo " Installation Completed of  HDFS3 Sink Connector "

echo " Installing Confluent Kafka Debezium Source Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt debezium/debezium-connector-mysql:1.5.0
echo " Installation Completed of  Debezium Source Connector "

echo " Installing Confluent Kafka Cassandra Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-cassandra:2.0.0
echo " Installation Completed of  Cassandra Sink Connector "

echo " Installing Confluent Kafka MongoDB Source/Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.5.1
echo " Installation Completed of  MongoDB Source/Sink Connector "


echo " Starting Spark Services "
# Start Spark Master
/home/vagrant/bigdata/spark/sbin/start-master.sh
# Start Spark Slaves
/home/vagrant/bigdata/spark/sbin/start-slaves.sh

#Check if Hadoop Services and Spark Services started 
/home/vagrant/bigdata/java/bin/jps


#Execute a Spark Example
echo "------------RUNNING SPARK EXAMPLE ------------------------------"
/home/vagrant/bigdata/spark/bin/run-example SparkPi 10

# Check whether the Spark shell is running in local mode
#/home/vagrant/bigdata/spark/bin/spark-shell --master local[*]

# Run Spark shell is running in YARN mode
# /home/vagrant/bigdata/spark/bin/spark-shell --master spark://master:7077

echo " Stoping Spark Services "

# Stop Spark Slaves
/home/vagrant/bigdata/spark/sbin/stop-slaves.sh
# Stop Spark Master
/home/vagrant/bigdata/spark/sbin/stop-master.sh

echo " Starting Confluent Services "
set CONFLUENT_HOME=/home/vagrant/bigdata/confluent;/home/vagrant/bigdata/confluent/bin/confluent local services start

#Check if all confluent Services started 
/home/vagrant/bigdata/java/bin/jps

echo " Stoping Confluent Services "
set CONFLUENT_HOME=/home/vagrant/bigdata/confluent;/home/vagrant/bigdata/confluent/bin/confluent local services stop

echo " Your Kafka environment is ready"
