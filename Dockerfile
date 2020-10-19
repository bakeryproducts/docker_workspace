FROM ubuntu:20.04

ARG NAME
ARG CONFIG
ARG PORT_JUP
ENV PORT_JUP=$PORT_JUP
ARG PUB
ARG HOST
ARG PROJECT_PATH

ARG HOST_NAME
ARG HOST_IP
ENV HOST_NAME=$HOST_NAME
ENV HOST_IP=$HOST_IP

RUN apt-get update --fix-missing && \
	apt-get upgrade -y && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		python3-pip \
		python3-dev \
		vim \
		git \
		openssh-server \
		gettext-base \
		iputils-ping \
		net-tools
RUN echo alias python='/usr/bin/python3' >> /root/.bashrc
RUN pip3 install --upgrade pip

#WORKDIR /root
COPY ./requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

#ADD $PROJECT_PATH/config /root/config
COPY $PROJECT_PATH/config/config.env /root/config/config.env

#jupyter lab
RUN jupyter lab --generate-config
COPY $PROJECT_PATH/config/jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
RUN envsubst < /root/.jupyter/jupyter_notebook_config.py > /root/.jupyter/jupyter_notebook_config.py

#SSH
RUN mkdir -m 600 /root/.ssh/
COPY $PUB /root/.ssh/authorized_keys
COPY $HOST /root/.ssh/hostkey
RUN echo alias hostrun='echo $HOST_NAME $HOST_IP' >> /root/.bashrc
#RUN echo alias hostrun='ssh -i /root/.ssh/hostkey -l $HOST_NAME $HOST_IP ' >> /root/.bashrc

RUN mkdir /var/run/sshd
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
#CMD jupyter lab & /usr/sbin/sshd -D 
