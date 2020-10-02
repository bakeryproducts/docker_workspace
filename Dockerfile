FROM ubuntu:20.04

ARG NAME
ARG CONFIG
#ARG PROJECT_PATH
#ARG TEMPLATE_PATH

RUN apt-get update --fix-missing && \
	apt-get upgrade -y && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		vim \
		git \
		openssh-server
WORKDIR /root
#CMD bash
