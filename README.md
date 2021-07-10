### Automated Setup & Installation Guide for 
### "Spark/Kafka/MySQL/Cassandra/MongoDB/Confluent"
### Single Node Cluster Environment
### using light-weight script
#### (Pseudo Distributed mode)
#### Version- 2021V1
##### ==============================================================================

#### Single Node _Hadoop/Spark/HBase/Kafka/Cassandra/MongoDB/Confluent_ Cluster on Windows using virtualization

###### Automation Script for creating single node _hadoop/spark/kafka/cassanda/mongodb_ cluster 
###### on Windows using Vagrant & Oracle Virtual Box 

#### Note :- To run this script, "Virtualization" property should be enabled for the Desktop/Laptop with Admin right
##### ==============================================================================
### Connection architecture

**Windows Environment --> Oracle Virtual Box --> Linux Environment**

### Functions of the template & script -
1. Install Hadoop stack, Spark, Kafka, Cassandra, MongoDB into Linux VM

##### ==============================================================================
### Pre-requisite Software
#### Download & Install the following software on Windows before running the script

1. Download and Install Oracle Virtual Box
   	
	https://download.virtualbox.org/virtualbox/5.2.38/VirtualBox-5.2.38-136252-Win.exe

2. Download and Install Vagrant version 2.2.4
  
	https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.msi
  
      ##### After vagrant installation , restart the system
	
3. Download SmarTTY

	https://sysprogs.com/SmarTTY/download/
	
	OR
	
	Download MobaXTerm
	
	https://mobaxterm.mobatek.net/download-home-edition.html

4. Download WinSCP

	https://winscp.net/eng/download.php
	

	
##### ==================================================
###  INSTALLATION PROCESS
##### ==================================================

#### Pre-requisite :- During entire installation procedure your Laptop/Desktop should be connected with Internet.
#### Minimum RAM Required :- 8 GB

1. Download the script file in Windows

   #####   https://github.com/rajuchal/spark-kafka-lw-2021V1/archive/refs/heads/master.zip

2. _"spark-kafka-lw-2021V1-master.zip"_ file will be downloaded , Unzip the file "spark-kafka-lw-2021V1-master.zip"
   ######  Right click on "spark-kafka-lw-2021V1-master.zip" -->Select "extract here"
   ######  Rename the extracted folder "spark-kafka-lw-2021V1-master" to "spark-kafka-lw-2021V1"

3. Copy the extracted root folder "spark-kafka-lw-2021V1" into C-drive

4. Open the Windows Command Prompt as "Administrator"

5. Change the directory to the extracted folder - "hadoop-lw-2021V1-main" in the Command Prompt

6. Run "setup.cmd"

   ##### C:\spark-kafka-lw-2021V1> setup.cmd

   ##### ------------- Wait till you get back the Command Prompt
   ##### ------------- Depending on the bandwidh total installation may take 45 mins to 1 hr time

6. After getting back the Command Prompt type "vagrant ssh" to login to Linux Box

   ##### C:\spark-kafka-lw-2021V1>vagrant ssh

   ##### vagrant@master:~$ jps
		11538 Jps
		
##### ==========================================================================
##### USE SmarTTY/MobaXTerm/ WinSCP to Connect with the Linux Node fron Windows

##### ===========================================================================

#### For details installation & setup , check the pdf file shared in the extracted folder.

##### =============================================================================

#### Commands to start services

##### =============================================================================

1.  Start Spark Services in Linux VM
    ##### $ start-master.sh
    ##### $ start-slaves.sh

2. Start Spark(Scala/Java) Shell  in Linux VM

    ##### $ spark-shell --master spark://localhost:7077

3. Start Spark(Python) Shell  in Linux VM

    ##### $ pyspark --master spark://localhost:7077

4. Start the Confluent Services

    ##### $ confluent local services start

### *Note-*
#### Installation directory in Linux VM - /home/vagrant/bigdata
#### Default user name for Windows & Linux VM - vagrant
#### Default password for Windows & Linux VM - vagrant
#### Check the installation & configuration guide pdf for detail instructions available in the extracted folder

:+1: **_Happy Clustering_** :shipit:

