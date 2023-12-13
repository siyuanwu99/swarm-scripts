#!/bin/bash

# Path to the YAML file
YAML_FILE="robots.yaml"
TEMP_FILE="working_robots.txt"

# Read robot names and IPs from the YAML file
# Assuming the YAML structure is like:
# robots:
#   - name: "robot1"
#     ip: "192.168.1.10"
#   - name: "robot2"
#     ip: "192.168.1.11"
# ...

# Readd YAML file from input
if [ $# -eq 1 ]; then
	YAML_FILE=$1
fi

declare -a working_ips
declare -a working_names
declare -a working_groups
while IFS=, read -r name ip sensor; do
	working_ips+=("$ip")
	working_names+=("$name")
	working_groups+=("$sensor")
done <"$TEMP_FILE"

length=${#working_ips[@]}
for ((i = 0; i < length; i++)); do
	name=${working_names[$i]}
	ip=${working_ips[$i]}
	sensor=${working_groups[$i]}
	echo "Processing robot $name with IP $ip in with $sensor..."

	# Commands to run depending on the group
	if [ "$sensor" == "realsense" ]; then
		cmd="gvio"
	elif [ "$sensor" == "lidar" ]; then
		cmd="ekf"
	else
		cmd="echo Unknown group"
	fi

	# SSH and tmux session configuration
	ssh -t "nv@$ip" "
				tmux send-keys -t $name:1.7 '$cmd' C-m
        exit;
    "
	echo "$name VINS started"
done
