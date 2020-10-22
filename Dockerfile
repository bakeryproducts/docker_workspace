FROM ubuntu:20.04

ARG NAME
ARG CONFIG
ARG PORT_JUP
ARG PUB
ARG HOST
ARG PROJECT_PATH
ARG SHARA
ARG HOST_NAME
ARG HOST_IP

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
		net-tools \
		neovim

#install avesome vim
#RUN git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
#RUN sh ~/.vim_runtime/install_awesome_vimrc.sh

#install python and pip
RUN echo alias python='/usr/bin/python3' >> /root/.bashrc
RUN pip3 install --upgrade pip

#install requirements
COPY ./requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

#copy config
COPY $PROJECT_PATH/config/config.env /root/config/config.env

#jupyter lab
RUN jupyter lab --generate-config
COPY $PROJECT_PATH/config/jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
RUN envsubst < /root/.jupyter/jupyter_notebook_config.py > /root/.jupyter/jupyter_notebook_config.py

#SSH
RUN mkdir -m 600 /root/.ssh/
COPY $PUB /root/.ssh/authorized_keys

#make docker hook
COPY $HOST /root/.ssh/hostkey
RUN echo "#!/bin/bash\nssh -i /root/.ssh/hostkey -l $HOST_NAME $HOST_IP \"cd ${SHARA} && docker \$@\"" >> /bin/docker
RUN chmod +x /bin/docker

#SSH-server
RUN mkdir /var/run/sshd
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD jupyter lab & /usr/sbin/sshd -D 
