#FROM ubuntu:18.04
#FROM debian:buster
#FROM nvcr.io/nvidia/pytorch:20.11-py3
FROM nvcr.io/nvidia/cuda:11.1-devel-ubuntu18.04

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        vim-gtk \
        ssh \
        sudo \
        curl 

RUN pip3 install --upgrade pip
        
ARG WORKSPACE_USERNAME
ARG RESOURCES_PATH 

ENV RESOURCES_PATH $RESOURCES_PATH  
ENV WORKSPACE_HOME "/home/$WORKSPACE_USERNAME"
ENV WORKSPACE_USERNAME $WORKSPACE_USERNAME

RUN useradd -rm -s /bin/bash -G sudo -u 1000 $WORKSPACE_USERNAME 
RUN echo "$WORKSPACE_USERNAME:$WORKSPACE_USERNAME" | chpasswd
RUN echo  "PATH=$RESOURCES_PATH/scripts:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" > /etc/environment

ENTRYPOINT python3 $RESOURCES_PATH/entrypoint.py $0 $@

EXPOSE 22
