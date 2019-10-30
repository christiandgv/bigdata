#!/bin/bash

# provisioning data
#rm master/data/user_ids_names &> /dev/null    
#python master/src/provisioning_data.py
#sudo rm -rf master/data/locations_most_actives master/data/users_most_actives

# create base hadoop cluster docker image
#docker build -f docker/base/Dockerfile -t irm/hadoop-cluster-base:latest docker/base

# create master node hadoop cluster docker image
#docker build -f docker/master/Dockerfile -t irm/hadoop-cluster-master:latest docker/master

echo "Starting cluster..."

# the default node number is 3
N=${1:-3}

docker network create --driver=bridge hadoop &> /dev/null

# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                christiandgv/hadoop-cluster-base-hdfs-spark:0.0.1
	i=$(( $i + 1 ))
done 

# start hadoop master container
docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                -p 18080:18080 \
                --name hadoop-master \
                --hostname hadoop-master \
                -v $PWD/data:/data \
                christiandgv/hadoop-cluster-master:0.0.2

echo "Making jobs. Please wait"

while [ ! -d data/locations_most_actives ]
do
  sleep 10
  #echo "Waiting..."
done

echo "Stoping cluster..."
docker stop hadoop-master

i=1
while [ $i -lt $N ]
do
	docker stop hadoop-slave$i
	
	i=$(( $i + 1 ))
done
