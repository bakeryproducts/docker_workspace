FROM ubuntu:20.04

#ARG NAME
#ARG CONFIG
ARG PUB
ENV PUB=$PUB
#ARG PROJECT_PATH
#ARG TEMPLATE_PATH

RUN apt-get update --fix-missing && \
	apt-get upgrade -y && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		vim \
		git \
		openssh-server
#SSH
#RUN mkdir /var/run/sshd
RUN mkdir -m 600 /root/.ssh/
ADD $PUB /root/.ssh/authorized_keys

RUN mkdir /var/run/sshd
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

#WORKDIR /root
#CMD cat /root/.ssh/authorized_keys
