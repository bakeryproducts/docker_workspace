FROM ubuntu:18.04
#FROM debian:buster

RUN apt-get update && \
    apt-get install -y \
        python3-pip \ 
        python3 \
        vim \
        ssh \
        curl \
        openssh-server \
        sudo
        
ARG USERNAME
ARG RESOURCES_PATH 

ENV RESOURCES_PATH $RESOURCES_PATH  
ENV WORKSPACE_HOME "/home/$USERNAME"
ENV USERNAME $USERNAME

##########################################
RUN pip3 install ranger-fm
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 
##########################################


RUN useradd -rm -s /bin/bash -G sudo -u 1000 $USERNAME 
RUN  echo "$USERNAME:$USERNAME" | chpasswd


EXPOSE 22
#CMD ["/bin/bash"]
CMD ["python3", "/resources/docker-entrypoint.py"] 