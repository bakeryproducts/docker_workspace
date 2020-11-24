FROM ubuntu:18.04
#FROM debian:buster

RUN apt-get update && \
    apt-get install -y \
        vim \
        ssh \
        curl \
        openssh-server \
        sudo
        
ARG USER_HOME_PATH
ARG USERNAME

RUN useradd -rm -d $USER_HOME_PATH -s /bin/bash -g root -G sudo -u 1000 $USERNAME 
RUN  echo 'gsm:gsm' | chpasswd

RUN echo  $LOCAL_PUB_KEY
#SSH
RUN mkdir -m 600 $USER_HOME_PATH/.ssh/
#COPY ./keys/id.pub $USER_HOME_PATH/.ssh/authorized_keys # TODO change to >>


#SSH-server
RUN service ssh start


#RUN mkdir /var/run/sshd
#RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
#ENV NOTVISIBLE="in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile
#
#make utils

EXPOSE 22
