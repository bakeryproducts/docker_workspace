#!/bin/bash

#docker network create --subnet=172.29.0.0/16 sokolov_ws_net
set -e 

WORKSPACE_USERNAME="gsm"
RESOURCES_PATH="/resources"
WORKSPACE_HOME="/home/$WORKSPACE_USERNAME"
WORKSPACE_HOST_PATH="$PWD/workspace/"
DATASETS_HOST_PATH="/data/datasets/"
DOCKER_SOCK_PATH=$XDG_RUNTIME_DIR/docker.sock
#DOCKER_PORT_RANGE=[]
#DOCKER_NETWORK=sokolov_ws_net
#DOCKER_IP=172.29.0.232


mkdir -p $PWD/resources/keys
for filename in $HOME/.ssh/*.pub; do
    cp "$filename" $PWD/resources/keys
done


docker build -f ./Dockerfile \
             -t sokolov/wsbase:v02 \
            --build-arg WORKSPACE_USERNAME=$WORKSPACE_USERNAME \
            --build-arg RESOURCES_PATH=$RESOURCES_PATH \
	    .
            #--no-cache . &&

docker build -f ./Dockerfile.ws \
             -t sokolov/ws:v02 \
            --build-arg WORKSPACE_HOST_PATH=$WORKSPACE_HOST_PATH\
             .
           #--no-cache . &&

docker run  \
            --gpus all \
            --name sokolov_ws \
	    --shm-size=64g \
            -dt \
            -h sws \
            -p 9000:22 \
            -p 9001-9100:9001-9100 \
            -v $WORKSPACE_HOST_PATH/$WORKSPACE_USERNAME:$WORKSPACE_HOME \
            -v $PWD/resources:$RESOURCES_PATH \
            -v $DATASETS_HOST_PATH:/datasets\
    	    -v $DOCKER_SOCK_PATH:/var/run/docker.sock \
            --net sokolov_ws_net \
            --ip 172.29.0.232 \
            sokolov/ws:v02 
