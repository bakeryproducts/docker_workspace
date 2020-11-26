FROM sokolov/wsbase:v01

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 

RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        git \
        zsh \
        gettext-base
        #iputils-ping \
        #net-tools \
        #build-essential \
        
USER $USERNAME
RUN pip3 install jupyterlab \ 
                    ranger-fm
COPY resources/config/requirements.txt /tmp
RUN pip3 install -r /tmp/requirements.txt

USER root
CMD ["python3", "/resources/scripts/run_workspace.py"] 
#CMD ["/bin/bash"]