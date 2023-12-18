#!/bin/bash

# Default robot list file
ROBOT_FILE="working_robots.txt"
ROBOT_NAME=""

shut_down() {
	local robot_name=$1
	local robot_ip=$2
	echo "nv@$robot_ip"

	ssh -Tq "nv@$robot_ip" "
				tmux send-keys -t $robot_name:1.1 C-c C-m
				tmux send-keys -t $robot_name:1.9 'sleep 1 && land' C-m
				echo '[$robot_name] Landing.'
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
	shut_down "$name" "$ip" &

done <"$ROBOT_FILE"
