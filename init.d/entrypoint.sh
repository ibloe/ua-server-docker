#!/bin/bash +e
# catch signals as PID 1 in a container

# SIGNAL-handler
term_handler() {

  echo "terminating ssh ..."
  /etc/init.d/ssh stop

  exit 143; # 128 + 15 -- SIGTERM
}

# on callback, stop all started processes in term_handler
trap 'kill ${!}; term_handler' SIGINT SIGKILL SIGTERM SIGQUIT SIGTSTP SIGSTOP SIGHUP

# run applications in the background
echo "starting ssh ..."
/etc/init.d/ssh start

# create netx "cifx0" ethernet network interface 
#/opt/cifx/cifx0daemon

#start the network-manager
/etc/init.d/network-manager start

#stop/start the networking
/etc/init.d/networking stop
/etc/init.d/networking start

#enable multicast for static ip configuration
/sbin/ifconfig etho multicast
/sbin/route -n add -net 224.0.0.0 netmask 240.0.0.0 dev eth0

echo "starting opc-ua-server"
sudo ./home/pi/opc-ua-server/opc-ua-server

# wait forever not to exit the container
while true
do
  tail -f /dev/null & wait ${!}
done

exit 0
