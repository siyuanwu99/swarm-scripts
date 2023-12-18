#!/bin/bash

# Default robot list file
ROBOT_FILE="working_robots.txt"
ROBOT_NAME=""

shut_down() {
	local robot_name=$1
	local robot_ip=$2
	local robot_pwd=$3 # password for sudo
	echo "nv@$robot_ip"

	ssh -tt "nv@$robot_ip" "
					echo '[$robot_name] Shutting down...'
					echo '$robot_pwd' | sudo -S shutdown now 
        	exit;
    		"

}

# Read from $ROBOT_FILE and apply shutdown command to each robot
while IFS=, read -r name ip sensor; do
	# Run commands only for the specified robot if ROBOT_NUMBER is set
	if [[ -n $ROBOT_NAME && $name != "swarm$ROBOT_NAME" ]]; then
		continue
	fi
	echo "[$name] Shutting down..."
	if [ "$sensor" == "realsense" ]; then
		shut_down "$name" "$ip" "nv" &
	elif [ "$sensor" == "lidar" ]; then
		shut_down "$name" "$ip" "nv" &
	elif [ "$sensor" == "coax" ]; then
		shut_down "$name" "$ip" " " &
	fi

done <"$ROBOT_FILE"
