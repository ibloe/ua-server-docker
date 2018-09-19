#!/bin/bash +e
# catch signals as PID 1 in a container

# SIGNAL-handler
term_handler() {
   echo "terminating node-red ..."
   /etc/init.d/nodered.sh stop
   
   echo "terminating ssh ..."
  sudo /etc/init.d/ssh stop
  
  exit 143; # 128 + 15 -- SIGTERM
}

# on callback, stop all started processes in term_handler
trap 'kill ${!}; term_handler' SIGINT SIGKILL SIGTERM SIGQUIT SIGTSTP SIGSTOP SIGHUP

# run applications in the background
/etc/init.d/nodered.sh start & 

echo "starting ssh ..."
sudo /etc/init.d/ssh start

echo "starting TestCrossPi"

sudo ./home/pi/opc-ua-server/opc-ua-server


# wait forever not to exit the container
while true
do
  tail -f /dev/null & wait ${!}
done

exit 0