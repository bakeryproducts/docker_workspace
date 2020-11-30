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
        
ARG USERNAME
ARG RESOURCES_PATH 

ENV RESOURCES_PATH $RESOURCES_PATH  
ENV WORKSPACE_HOME "/home/$USERNAME"
ENV USERNAME $USERNAME

RUN useradd -rm -s /bin/bash -G sudo -u 1000 $USERNAME 
RUN  echo "$USERNAME:$USERNAME" | chpasswd

ENTRYPOINT python3 $RESOURCES_PATH/entrypoint.py $0 $@

EXPOSE 22
