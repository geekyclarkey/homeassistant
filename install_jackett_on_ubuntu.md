
# How to install Jackett on ubuntu server 16.04.


### Install libcurl and bzip for unpacking Jackett, include mono-devel as well to prevent bugs with some private trackers
`sudo apt-get update`  
`sudo apt-get install libcurl4-openssl-dev bzip2 mono-devel -y`  

### Download the latest Jackett release, I have automated grabbing the newest release but if it doesn’t work check here or here to get the URL.
`jackettver=$(wget -q https://github.com/Jackett/Jackett/releases/latest -O - | grep -E \/tag\/ | awk -F "[><]" '{print $3}')`  
`wget -q https://github.com/Jackett/Jackett/releases/download/v0.12.1638/Jackett.Binaries.Mono.tar.gz`  
* Change the Version if you want a newer version

### Unpack the Jackett release (adjust the filename if you want to downloaded a newer version)
`tar -xvf Jackett*`

### Make the Jackett installation folder
`sudo mkdir /opt/jackett`

### Move the unzipped Jackett installation
`sudo mv Jackett/* /opt/jackett`

### Change ownership of Jackett to your main user
`sudo chown -R username:username /opt/jackett`   

### Test running Jackett which runs on port 9117 http://ip.address:9117
`mono /opt/jackett/JackettConsole.exe`
Kill the Jackett process with Ctrl+C so we can start it automatically on boot using an init.d script
* Make sure you have the latest version of mono installed [Click Here](https://www.mono-project.com/download/stable/#download-lin-ubuntu) for instructions.

# How to Autostart Jackett on Ubuntu 16.04

## You only need to use the init.d script or the upstart script

### Jackett init.d Script

Create the Jackett init.d startup script  
`sudo nano /etc/init.d/jackett`
Paste the Jackett init.d script, adjust your RUN_AS value to your main user
```
#! /bin/sh
### BEGIN INIT INFO
# Provides: Jackett
# Required-Start: $local_fs $network $remote_fs
# Required-Stop: $local_fs $network $remote_fs
# Should-Start: $NetworkManager
# Should-Stop: $NetworkManager
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: starts instance of Jackett
# Description: starts instance of Jackett using start-stop-daemon
### END INIT INFO

############### EDIT ME ##################
# path to app
APP_PATH=/opt/jackett

# user
RUN_AS=ubuntu

# path to mono bin
DAEMON=$(which mono)

# Path to store PID file
PID_FILE=/var/run/jackett/jackett.pid
PID_PATH=$(dirname $PID_FILE)

# script name
NAME=jackett

# app name
DESC=Jackett

# startup args
EXENAME="JackettConsole.exe"
DAEMON_OPTS=" "$EXENAME

############### END EDIT ME ##################

JACKETT_PID=`ps auxf | grep $EXENAME | grep -v grep | awk '{print $2}'`

test -x $DAEMON || exit 0

set -e

#Look for PID and create if doesn't exist
if [ ! -d $PID_PATH ]; then
	mkdir -p $PID_PATH
	chown $RUN_AS $PID_PATH
fi

if [ ! -d $DATA_DIR ]; then
	mkdir -p $DATA_DIR
	chown $RUN_AS $DATA_DIR
fi

if [ -e $PID_FILE ]; then
	PID=`cat $PID_FILE`
		if ! kill -0 $PID > /dev/null 2>&1; then
		echo "Removing stale $PID_FILE"
		rm $PID_FILE
	fi
fi

echo $JACKETT_PID > $PID_FILE

case "$1" in
start)
if [ -z "${JACKETT_PID}" ]; then
	echo "Starting $DESC"
	rm -rf $PID_PATH || return 1
	install -d --mode=0755 -o $RUN_AS $PID_PATH || return 1
	start-stop-daemon -d $APP_PATH -c $RUN_AS --start --background --pidfile $PID_FILE --exec $DAEMON -- $DAEMON_OPTS
	else
	echo "Jackett already running."
fi
;;
stop)
echo "Stopping $DESC"
echo $JACKETT_PID > $PID_FILE
start-stop-daemon --stop --pidfile $PID_FILE --retry 15
;;

restart|force-reload)
echo "Restarting $DESC"
start-stop-daemon --stop --pidfile $PID_FILE --retry 15
start-stop-daemon -d $APP_PATH -c $RUN_AS --start --background --pidfile $PID_FILE --exec $DAEMON -- $DAEMON_OPTS
;;
status)
# Use LSB function library if it exists
if [ -f /lib/lsb/init-functions ]; then
	. /lib/lsb/init-functions
if [ -e $PID_FILE ]; then
	status_of_proc -p $PID_FILE "$DAEMON" "$NAME" && exit 0 || exit $?
	else
	log_daemon_msg "$NAME is not running"
	exit 3
fi

else
# Use basic functions
if [ -e $PID_FILE ]; then
	PID=`cat $PID_FILE`
if kill -0 $PID > /dev/null 2>&1; then
	echo " * $NAME is running"
	exit 0
fi
else
	echo " * $NAME is not running"
	exit 3
fi
fi
;;
*)
N=/etc/init.d/$NAME
echo "Usage: $N {start|stop|restart|force-reload|status}" >&2
exit 1
;;
esac

exit 0
```

### Make the Jackett init.d script executable
`sudo chmod +x /etc/init.d/jackett`

### Update your system to use the Jackett init.d script
`sudo update-rc.d jackett defaults`

### Now start the Jackett service
`sudo service jackett start`

## Jackett Upstart Script

### Create the Jackett upstart file
`sudo nano /etc/init/jackett.conf`

### Paste the Jackett upstart script, change user if there is a specific user you want to run Jackett as
```
#Jackett startup script

env DIR=/opt/jackett
setuid user
setgid nogroup

start on runlevel [2345]

stop on runlevel [016]

#respawn

exec mono $DIR/JackettConsole.exe
```









