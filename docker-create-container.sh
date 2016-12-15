#!/usr/bin/env bash

NETWORK_NAME=dm-network
IMAGE_NAME=$1
CONTAINER_NAME=$2
HOST_PORT=$3

. base_container.properties

docker network create -d bridge --subnet 172.25.0.0/16 $NETWORK_NAME # TODO ignore error if network already exists

docker rm -f $CONTAINER_NAME
docker run --restart always --net=$NETWORK_NAME --name $CONTAINER_NAME -p $HOST_PORT:3306 -e MYSQL_ROOT_PASSWORD=$DB_PASSWORD -d $IMAGE_NAME
if [ $? -eq 0 ]; then
    while [[ ! `docker logs $CONTAINER_NAME 2>&1 | grep 'Server socket created'` ]]; do echo -n "." && sleep 1; done
    echo -e "\nMySQL daemon started\n"
fi