# Info

####
versions:
* os: ubuntu/bionic64
* java: oracle-java8-installer
* kafka: kafka_2.12-2.1.0
* zookeeper: zookeeper-3.4.13

Change versions you can in Vagrantfile and start1.sh script
####
This Vagratfile create cluster from 5 VM, on 5 VMs install kafka and on 3 VMs install zookeeper.
Zookeeper install on first 3 VM and create one cluster.
All settings you can modified in Vagrantfile and start1.sh script.
####
Read logs applications in VMs in:
```
less /home/kafka/kafka/kafka.log
less /usr/local/zookeeper/zookeeper.out
```
