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

RUN useradd -rm -d $USER_HOME_PATH -s /bin/bash -G sudo -u 1000 $USERNAME 
RUN  echo "$USERNAME:$USERNAME" | chpasswd

#SSH
COPY ./keys/sshd_config /etc/ssh/
RUN mkdir -m 700 $USER_HOME_PATH/.ssh/
COPY ./keys/id.pub $USER_HOME_PATH/.ssh/authorized_keys
RUN chown -R $USERNAME:$USERNAME $USER_HOME_PATH/.ssh


#SSH-server
RUN service ssh start
#RUN mkdir /var/run/sshd
#RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
#make utils

EXPOSE 22
