FROM ubuntu:20.04

ARG NAME
ARG CONFIG
ARG PORT_JUP
ENV PORT_JUP=$PORT_JUP
ARG PUB
ENV PUB=$PUB
ARG PROJECT_PATH

RUN apt-get update --fix-missing && \
	apt-get upgrade -y && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		python3-pip \
		python3-dev \
		vim \
		git \
		openssh-server \
		gettext-base
RUN echo alias python='/usr/bin/python3' >> /root/.bashrc
RUN pip3 install --upgrade pip

#WORKDIR /root
COPY ./requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

#ADD $PROJECT_PATH/config /root/config
COPY $PROJECT_PATH/config/config.env /root/config/config.env

#jupyter lab
#WORKDIR /root
RUN jupyter lab --generate-config
COPY $PROJECT_PATH/config/jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
RUN envsubst < /root/.jupyter/jupyter_notebook_config.py > /root/.jupyter/jupyter_notebook_config.py

#SSH
#RUN mkdir /var/run/sshd
RUN mkdir -m 600 /root/.ssh/
ADD $PUB /root/.ssh/authorized_keys

RUN mkdir /var/run/sshd
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
#CMD ["/usr/sbin/sshd", "-D"]

#WORKDIR /root
#CMD cat /root/.ssh/authorized_keys
