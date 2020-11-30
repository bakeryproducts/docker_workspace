FROM sokolov/wsbase:v02

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 

ARG WORKSPACE_HOST_PATH 
ENV WORKSPACE_HOST_PATH $WORKSPACE_HOST_PATH  

RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        git \
        zsh \
        gettext-base \
        docker.io \
        htop \
        screen 
        #iputils-ping \
        #net-tools \
        #build-essential \
        
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - &&  apt-get install -y nodejs

RUN cd /tmp && wget http://eradman.com/entrproject/code/entr-4.6.tar.gz && \
    tar -zxf entr-4.6.tar.gz && cd entr-4.6 && ./configure && make test && make install


RUN echo 'ZDOTDIR=~/.config/zsh' >> /etc/zsh/zshenv
COPY resources/config/requirements.txt /tmp

CMD "python3 $RESOURCES_PATH/scripts/run_workspace.py"
