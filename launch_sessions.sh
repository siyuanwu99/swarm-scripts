#!/bin/bash

# Function to manage robot sessions
manage_sessions() {
	local robot_name=$1
	local robot_ip=$2
	local robot_sensor=$3
	# Insert logic to start, monitor, and terminate sessions
	# Make use of robot_name, robot_ip, and robot_sensor as needed
	echo "---------- $name ----------"
	echo "IP: $ip"
	echo "Sensor: $sensor"

	# Commands to run depending on the group
	if [ "$robot_sensor" == "realsense" ]; then
		shell_type="zsh"
		cmd="roslaunch realsense2_camera rs_camera.launch"
	elif [ "$robot_sensor" == "lidar" ]; then
		shell_type="zsh"
		cmd="roslaunch fast_lio my_mapping_mid360.launch"
	elif [ "$robot_sensor" == "coax" ]; then
		shell_type="bash"
		cmd="lio"
	else
		cmd="echo Unknown group"
	fi

	# SSH and tmux session configuration
	ssh -tt "nv@$robot_ip" "
				tmux list-sessions &> /dev/null && tmux kill-session -a
        tmux new-session -d -s $robot_name
				tmux split-window -h -p 50
				tmux select-pane -t 1
				tmux split-window -v -p 75
				tmux select-pane -t 3
				tmux split-window -v -p 80
				tmux split-window -v -p 80
				tmux split-window -v -p 80
				tmux split-window -v -p 80
				tmux split-window -v -p 80
				tmux split-window -v -p 80

				for pane in {1..9}; do
    				tmux send-keys -t $robot_name:1.\$pane 'cd ~/star_exploration_ws && source setup.$shell_type' C-m
				done

				tmux send-keys -t $robot_name:1.3 'jtop' C-m
				tmux send-keys -t $robot_name:1.4 'sleep 1 && mav' C-m
				tmux send-keys -t $robot_name:1.5 'sleep 4 && bridge' C-m
				tmux send-keys -t $robot_name:1.6 'sleep 5 && $cmd' C-m

				echo '[$robot_name] Initialized.'

        exit;
    	"
	echo "Started tmux session for $robot_name"

	if [ "$robot_sensor" == "realsense" ]; then
		ssh -t "nv@$robot_ip" "tmux send-keys -t $robot_name:1.7 'sleep 15 && gvio' C-m"
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
	manage_sessions "$name" "$ip" "$sensor"
done
