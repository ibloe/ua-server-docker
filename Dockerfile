#use latest armv7hf compatible debian version from group resin.io as base image
FROM balenalib/armv7hf-debian:stretch

#enable building ARM container on x86 machinery on the web (comment out next line if not built as automated build on docker hub) 
RUN [ "cross-build-start" ]

#labeling
LABEL maintainer="ibloecher@hilscher.com" \ 
    version="V0.0.0.2" \
    description="Debian OPC UA"

#version
ENV HILSCHERNETPI_NETX_TCPIP_NETWORK_INTERFACE_VERSION 0.9.4
ENV OPC_UA_VERSION 0.0.0.2


#copy files
COPY "./init.d/*" /etc/init.d/ 
COPY "./driver/*" "./firmware/*" /tmp/
COPY "./opc-ua-server/" /home/pi/opc-ua-server/

#do installation
RUN apt-get update  \
    && apt-get install -y openssh-server build-essential network-manager ifupdown \
#do users root and pi    
    && useradd --create-home --shell /bin/bash pi \
    && echo 'root:root' | chpasswd \
    && echo 'pi:raspberry' | chpasswd \
    && adduser pi sudo \
    && mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
	&& sudo chmod -R g+rwx /home/pi/opc-ua-server/ \
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
#install netX driver and netX ethernet supporting firmware
    && dpkg -i /tmp/netx-docker-pi-drv-1.1.3-r1.deb \
    && dpkg -i /tmp/netx-docker-pi-pns-eth-3.12.0.8.deb \
#compile netX network daemon
    && gcc /tmp/cifx0daemon.c -o /opt/cifx/cifx0daemon -I/usr/include/cifx -Iincludes/ -lcifx -pthread \
#enable automatic interface management
    && sudo sed -i 's/^managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf \
#copy the cifx0 interface configuration file 
    && cp /tmp/cifx0 /etc/network/interfaces.d \
#clean up
    && rm -rf /tmp/* \
    && apt-get remove build-essential \
    && apt-get -yqq autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*
	
#OPC UA TCP & SSH
EXPOSE 4840
EXPOSE 22

#set the entrypoint
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]

#set STOPSGINAL
STOPSIGNAL SIGTERM

#stop processing ARM emulation (comment out next line if not built as automated build on docker hub)
RUN [ "cross-build-end" ]
