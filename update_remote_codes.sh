#!/bin/bash

remote_git_stash_and_pull() {
	local robot_name=$1
	local robot_ip=$2

	# SSH and tmux session configuration
	ssh -Tq "nv@$robot_ip" "
				echo '[$robot_name] Updating code...'
				cd ~/star_exploration_ws/src/swarm_exploration_project
				git stash
				git pull
				git stash pop
				exit;
				"
}

remote_catkin_make() {

	local robot_name=$1
	local robot_ip=$2

	# SSH and tmux session configuration
	ssh -Tq "nv@$robot_ip" "
				echo '[$robot_name] Updating code...'
				cd ~/star_exploration_ws/src/swarm_exploration_project
				source devel/setup.zsh
				catkin_make
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

# Default robot list file
ROBOT_FILE="working_robots.txt"
KILL=0
ROBOT_NAME=""
COPY=0
DELETE=0

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
	-c | --copy)
		COPY=1
		;;
	-d | --delete)
		DELETE=1
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
while IFS=, read -r name ip sensor; do

	# Run commands only for the specified robot if ROBOT_NUMBER is set
	if [[ -n $ROBOT_NAME && $name != "swarm$ROBOT_NAME" ]]; then
		continue
	fi

	echo "$name $ip $sensor"

	if [ "$KILL" -eq 0 ]; then
		remote_git_stash_and_pull "$name" "$ip" "$sensor" "$ID" "$NUM" &
	elif [ "$COPY" -eq 1 ]; then
		echo "Copying $name"
		send_bags_back "$name" "$ip" &
	elif [ "$DELETE" -eq 1 ]; then
		echo "Deleting $name"
		delete_bags "$name" "$ip" &
	elif [ "$KILL" -eq 1 ]; then
		echo "Killing $name"
		kill_commands "$name" "$ip" "$sensor" &
	else
		echo "Unknown option"
		exit 1
	fi
done <"$ROBOT_FILE"

wait
