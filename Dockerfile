#use latest armv7hf compatible raspbian OS version from group resin.io as base image
FROM resin/armv7hf-debian:stretch
 # Enable systemd
ENV INITSYSTEM on
 #enable building ARM container on x86 machinery on the web (comment out next line if built on Raspberry) 
RUN [ "cross-build-start" ]
 #labeling
LABEL maintainer="ibloecher@hilscher.com" \ 
    version="V0.0.0.1" \
    description="Debian OPC UA"
 #version
ENV OPC_UA_VERSION 0.0.0.1
 #java options
ENV _JAVA_OPTIONS -Xms64M -Xmx128m
 #Create directories and copy files with group rights for user id 1000 for read, write and execute
RUN mkdir -p -m g=rwx /home/pi/opc-ua-server/
 COPY "./init.d/*" /etc/init.d/
COPY "./opc-ua-server/" /home/pi/opc-ua-server/
 #install helper programs
RUN apt-get update  \
    && apt-get install wget \
    && wget https://archive.raspbian.org/raspbian.public.key -O - | apt-key add - \
    && echo 'deb http://raspbian.raspberrypi.org/raspbian/ stretch main contrib non-free rpi' | tee -a /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y openssh-server \
    && mkdir /var/run/sshd \
    && sed -i 's@#force_color_prompt=yes@force_color_prompt=yes@g' -i /etc/skel/.bashrc \
    && useradd --create-home --shell /bin/bash pi \
    && echo 'pi:raspberry' | chpasswd \
    && adduser pi sudo \
    && echo pi " ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/010_pi-nopasswd \
    #add user pi to group root
    && usermod -aG root pi \    
    && apt-get install -y --no-install-recommends \
    less \
    kmod \
    nano \
    net-tools \
    ifupdown \
    iputils-ping \
    i2c-tools \
    usbutils \
    build-essential \
    git \
    apt-utils \
    dialog \
    curl build-essential \
    vim-common \
    vim-tiny \
    gdb \
    psmisc \
    && sudo chmod -R g+rwx /etc/init.d \
    && sudo chmod -R g+rwx /home/pi/opc-ua-server/ \
    #install node.js
    && curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - \
    && apt-get install -y nodejs \
    #install Node-RED
    && npm install -g --unsafe-perm node-red \
#clean up
    && apt-get remove curl \
    && apt-get -yqq autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*
 #Node-RED Port
EXPOSE 1880
#SSH Port
EXPOSE 22
#OPC UA TCP
EXPOSE 4840
 #set entrypoint
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]
 #set STOPSGINAL
STOPSIGNAL SIGTERM
 #stop processing ARM emulation (comment out next line if built on Raspberry)
RUN [ "cross-build-end" ]
