#!/bin/bash

# Function to manage robot sessions
run_commands() {
	local robot_name=$1
	local robot_ip=$2
	local robot_sensor=$3
	# Insert logic to start, monitor, and terminate sessions
	# Make use of robot_name, robot_ip, and robot_sensor as needed

	# Commands to run depending on the group
	if [ "$robot_sensor" == "realsense" ]; then
		echo "---------- $robot_name ----------"
		echo "IP: $robot_ip"
		echo "Sensor: $robot_sensor"
		# SSH and tmux session configuration
		ssh -t "nv@$robot_ip" "
						tmux send-keys -t $robot_name:1.7 C-c C-m
						echo '[$robot_name] VINS started'
        		exit;
    		"
	else
		return
	fi
}

# Function to display help message
show_help() {
	echo "Usage: $0 [options]"
	echo ""
	echo "Options:"
	echo "  -h, --help        Show this help message."
	echo "  -f, --file        Specify the robot list file to process. Default is 'working_robots.txt'."
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

# Function to ping a robot
ping_robot() {
	local robot_ip=$1
	# Insert ping logic here
	# Return 0 for success, non-zero for failure
	if ping -c 1 "$robot_ip" &>/dev/null; then
		return 0 # success
	else
		return 1 # failure
	fi

}

# Default robot list file
ROBOT_FILE="working_robots.txt"

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
cat "$ROBOT_FILE" | while IFS=, read -r name ip sensor; do
	echo "$name $ip $sensor"
	run_commands "$name" "$ip" "$sensor"
done
