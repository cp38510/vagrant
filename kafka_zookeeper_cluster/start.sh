#!/bin/bash

#Install Java
add-apt-repository ppa:webupd8team/java -y > /dev/null
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections > /dev/null 2>&1
#apt update
apt-get install -y oracle-java8-installer > /dev/null 2>&1

echo -e "192.168.50.11 kaf1.pool\n192.168.50.12 kaf2.pool\n192.168.50.13 kaf3.pool\n192.168.50.14 kaf4.pool\n192.168.50.15 kaf5.pool" >> /etc/hosts

#Install Kafka
useradd kafka -m
adduser kafka sudo
mkdir /home/kafka/Downloads
curl "http://www-eu.apache.org/dist/kafka/2.1.0/kafka_2.12-2.1.0.tgz" -o /home/kafka/Downloads/kafka.tgz > /dev/null 2>&1
mkdir /home/kafka/kafka
tar -xvzf /home/kafka/Downloads/kafka.tgz -C /home/kafka/kafka
mv /home/kafka/kafka/kafka_2.12-2.1.0/* /home/kafka/kafka
#echo "\ndelete.topic.enable = true" >> ~/kafka/config/server.properties

#copy configuration file's
cp /vagrant/kafka.service /etc/systemd/system/kafka.service
cp /vagrant/zookeeper.service /etc/systemd/system/zookeeper.service
mv /home/kafka/kafka/config/zookeeper.properties{,.BAK}
mv /home/kafka/kafka/config/server.properties{,.BAK}
cp /vagrant/kafka.server.properties /home/kafka/kafka/config/server.properties
chown kafka. -R /home/kafka

#Install zookeeper
wget http://apache-mirror.rbc.ru/pub/apache/zookeeper/zookeeper-3.4.13/zookeeper-3.4.13.tar.gz > /dev/null 2>&1
tar -zxf zookeeper-*.tar.gz -C /usr/local
mv -f /usr/local/zookeeper-* /usr/local/zookeeper
cp /vagrant/zookeeper.properties /usr/local/zookeeper/conf/zoo.cfg

#change var number to number hostname
sed -i 's%HOSTNAMENUMBER%'$(hostname |cut -c 4)'%g' /home/kafka/kafka/config/server.properties

#enable services
systemctl daemon-reload
systemctl enable kafka
systemctl enable zookeeper

#create myid file's for start zookeeper
mkdir -p /tmp/zookeeper/
echo "$(hostname |cut -c 4)" > /tmp/zookeeper/myid

#run zookeeper and kafka if number HOST < 4
if (( $(hostname |cut -c 4) < 4 ))
then
systemctl start zookeeper
systemctl start kafka
else
systemctl start kafka
fi


#read logs
#less /home/kafka/kafka/kafka.log
#less /usr/local/zookeeper/zookeeper.out



###for test
#/usr/local/zookeeper/bin/zkServer.sh status
#su -l kafka
#~/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic TutorialTopic
#echo "Hello, World" | ~/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic TutorialTopic > /dev/null
#~/kafka/bin/kafka-console-consumer.sh --bootstrap-server  localhost:9092 --topic TutorialTopic --from-beginning
