#!/bin/bash

# Function to manage robot sessions
run_planner() {
	local robot_name=$1
	local robot_ip=$2
	local robot_sensor=$3
	local id=$4
	local num=$5
	# Insert logic to start, monitor, and terminate sessions
	# Make use of robot_name, robot_ip, and robot_sensor as needed

	# Commands to run depending on the group
	echo "---------- $robot_name ----------"
	echo "IP: $robot_ip"
	echo "Sensor: $robot_sensor"
	# SSH and tmux session configuration

	cmd="roslaunch exploration_manager run_onboard.launch drone_id:=$id drone_num:=$num"
	echo $cmd
	ssh -Tq "nv@$robot_ip" "
					tmux send-keys -t $name:1.1 '$cmd' C-m
					echo '[$name] Planner started.'
        	exit;
    		"
}

kill_commands() {
	local robot_name=$1
	local robot_ip=$2
	# Insert logic to start, monitor, and terminate sessions
	# Make use of robot_name, robot_ip, and robot_sensor as needed

	# Commands to run depending on the group
	echo "---------- $robot_name ----------"
	echo "IP: $robot_ip"
	echo "Sensor: $robot_sensor"
	# SSH and tmux session configuration
	ssh -Tq "nv@$robot_ip" "
						tmux send-keys -t $robot_name:1.1 C-c C-m
						echo '[$robot_name] Planner killed'
        		exit;
    		"
}
# Function to display help message
show_help() {
	echo "Usage: $0 [options]"
	echo ""
	echo "Options:"
	echo "  -h, --help        Show this help message."
	echo "  -f, --file        Specify the robot list file to process. Default is 'working_robots.txt'."
	echo "  -k, --kill        Kill the running sessions."
	echo "  -n, --name        Specify the robot name to process. Default is all robots."
	echo ""
}

# Function to validate the robot list file
validate_file() {
	if [ ! -f "$1" ]; then
		echo "Error: File '$1' not found." 2>&1
		exit 1
	fi
}

# Function to read robot data from the file
read_robot_file() {
	local file=$1
	cat "$file"
}

# Default robot list file
ROBOT_FILE="working_robots.txt"
KILL=0
ROBOT_NAME=""

# Parse command line options
while [[ "$#" -gt 0 ]]; do
	case $1 in
	-h | --help)
		show_help
		exit 0
		;;
	-f | --file)
		ROBOT_FILE="$2"
		shift
		;;
	-k | --kill)
		KILL=1
		;;
	-n | --name)
		ROBOT_NAME="$2"
		shift
		;;
	*)
		echo "Unknown option: $1"
		show_help
		exit 1
		;;
	esac
	shift
done

# Validate and process the robot list file
validate_file "$ROBOT_FILE"
ID=0

# count number of robots (lines)
NUM=$(wc -l <"$ROBOT_FILE")

while IFS=, read -r name ip sensor; do

	# Run commands only for the specified robot if ROBOT_NUMBER is set
	if [[ -n $ROBOT_NAME && $name != "swarm$ROBOT_NAME" ]]; then
		continue
	fi
	ID=$((ID + 1))

	echo "$name $ip $sensor"

	if [ "$KILL" -eq 0 ]; then
		run_planner "$name" "$ip" "$sensor" "$ID" "$NUM"
	else
		echo "Killing $name"
		kill_commands "$name" "$ip" "$sensor"
	fi
done <"$ROBOT_FILE"
