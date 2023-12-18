#!/bin/bash

# Function to manage robot sessions
record_bags() {
	local robot_name=$1
	local robot_ip=$2
	local robot_sensor=$3
	local id=$4
	local num=$5
	# Commands to run depending on the group

	ssh -Tq "nv@$robot_ip" "
				tmux send-keys -t $robot_name:1.2 'rosbag record /exploration/global/odometry /sdf_map/occupancy_all  /planning/bspline /planning/new /planning/pos_cmd /planning/position_cmd_vis /planning/replan /planning/swarm_traj_recv /planning/swarm_traj_send /planning/travel_traj /planning_vis/frontier /planning_vis/prediction /planning_vis/topo_path /planning_vis/trajectory /planning_vis/viewpoints /planning_vis/visib_constraint /planning_vis/yaw /swarm_expl/drone_state_recv /swarm_expl/drone_state_send /swarm_expl/grid_tour_send /swarm_expl/hgrid_send /swarm_expl/pair_opt_recv /swarm_expl/pair_opt_res_recv /swarm_expl/pair_opt_res_send /swarm_expl/pair_opt_send /camera/infra1/image_rect_raw -o $robot_name.bag' C-m
				echo '[$robot_name] Recording RACER topics'
        exit;
    "
}

# Function to kill bag recording
kill_commands() {
	local robot_name=$1
	local robot_ip=$2

	# SSH and tmux session configuration
	ssh -Tq "nv@$robot_ip" "
						tmux send-keys -t $robot_name:1.2 C-c C-m
						echo '[$robot_name] Recording stopped'
        		exit;
    		"
}

# Function to copy bags from remote to local
send_bags_back() {
	local robot_name=$1
	local robot_ip=$2

	ssh -t "nv@$robot_ip" "
					tmux send-keys -t $robot_name:1.2 C-c C-m
					ls ~/star_exploration_ws | grep '$robot_name'
     	"
	scp "nv@$robot_ip:~/star_exploration_ws/$robot_name*.bag" .
}

# Function to delete bags from remote
delete_bags() {
	local robot_name=$1
	local robot_ip=$2
	ssh -t "nv@$ip" " tmux send-keys -t $name:1.2 'rm dbg*' C-m "
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
	echo "  -c, --copy        Copy the bags from remote to local."
	echo "  -d, --delete      Delete the bags from remote."
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

	if [ "$COPY" -eq 1 ]; then
		echo "Copying $name"
		send_bags_back "$name" "$ip" &
	elif [ "$DELETE" -eq 1 ]; then
		echo "Deleting $name"
		delete_bags "$name" "$ip" &
	elif [ "$KILL" -eq 1 ]; then
		echo "Killing $name"
		kill_commands "$name" "$ip" "$sensor" &
	elif [ "$KILL" -eq 0 ]; then
		echo "Recording $name"
		record_bags "$name" "$ip" "$sensor" &
	else
		echo "Unknown option"
		exit 1
	fi
done <"$ROBOT_FILE"

wait
