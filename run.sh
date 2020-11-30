#!/bin/bash
set -e 

#docker network create --subnet=172.29.0.0/16 sokolov_ws_net
mkdir -p $PWD/resources/keys
for filename in $HOME/.ssh/*.pub; do
    cp "$filename" $PWD/resources/keys
done

USERNAME="gsm"
RESOURCES_PATH="/resources"
WORKSPACE_HOME="/home/$USERNAME"
WORKSPACE_HOST_PATH="$PWD/workspace/"
ID=$(id -g $USER)

docker build -f ./Dockerfile \
             -t sokolov/wsbase:v02 \
            --build-arg USERNAME=$USERNAME \
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
            -di \
            -h sws \
            -p 9000:22 \
            -p 9001-9100:9001-9100 \
            -v $WORKSPACE_HOST_PATH/$USERNAME:$WORKSPACE_HOME \
            -v $PWD/resources:$RESOURCES_PATH \
	    -v /run/user/$ID/docker.sock:/var/run/docker.sock \
            --net sokolov_ws_net \
            --ip 172.29.0.232 \
            sokolov/ws:v01 
