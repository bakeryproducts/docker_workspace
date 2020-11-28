#!/bin/bash
set -e 

#docker network create --subnet=172.29.0.0/16 sokolov_ws_net
for filename in $HOME/.ssh/*.pub; do
    cp "$filename" $PWD/resources/keys
done

USERNAME="gsm"
RESOURCES_PATH="/resources"
WORKSPACE_HOME="/home/$USERNAME"

docker build -f ./Dockerfile \
             -t sokolov/wsbase:v01 \
            --build-arg USERNAME=$USERNAME \
            --build-arg RESOURCES_PATH=$RESOURCES_PATH \
            . 
            #--no-cache . &&

docker build -f ./Dockerfile.ws \
             -t sokolov/ws:v01 \
             .
           #--no-cache . &&

docker run  \
            --gpus all \
            --name sokolov_ws \
            -di \
            -h sws \
            -p 9000-9100:9000-9100 \
            -v $PWD/workspace/$USERNAME:$WORKSPACE_HOME \
            -v $PWD/resources:$RESOURCES_PATH \
            --net sokolov_ws_net \
            --ip 172.29.0.232 \
            sokolov/ws:v01 
