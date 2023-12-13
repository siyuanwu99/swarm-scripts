#!/bin/bash
# Exit on any error
set -e

# Variables
PASSWORD=
CURRENT_USER=$(logname)
USER_HOME="/home/$CURRENT_USER"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
EGO_SWARM_WS_DIR="$USER_HOME/ego_swarm_ws/"

# Function to install ROS and other dependencies
install_dependencies() {
	echo "[STAR Lab] Installing dependencies..."
	# echo $password | sudo -S apt-get update -y

	# Install ros dependencies
	echo "$PASSWORD" | sudo -S apt-get install -y ros-noetic-cv-bridge ros-noetic-tf2-ros ros-noetic-tf2-geometry-msgs ros-noetic-tf2-eigen ros-noetic-tf2

	# Install other dependencies
	echo "$PASSWORD" | sudo -S apt-get install -y libglfw3-dev libglew-dev libzmqpp-dev libdw-dev libarmadillo-dev

	echo "[STAR Lab] Dependencies installed!"
}

# Function to install racer
install_ego_swarm() {
	echo "[STAR Lab] Installing EGO-Swarm..."

	# Navigate to the workspace directory, create src directory if not exist
	echo "work tree dir $EGO_SWARM_WS_DIR"
	[ ! -d "$EGO_SWARM_WS_DIR" ] && mkdir -p "$EGO_SWARM_WS_DIR"
	cd "$EGO_SWARM_WS_DIR"
	[ ! -d "src" ] && mkdir -p src
	cd src
	[ -d "ego_swarm_v2" ] && rm ego_swarm_v2 -rf

	# Clone the required git repository
	git clone git@github.com:siyuanwu99/EGO-Swarm-v2.git ./ego_swarm_v2
	cd ..

	# Build the project
	catkin_make -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=1

	# Copy the compile_commands.json to the root directory
	jq -s 'map(.[])' build/**/compile_commands.json > compile_commands.json

	echo "[STAR Lab] EGO-Swarm has been successfully installed!"
}

# Main execution
main() {
	echo "Please enter your password: "

	read -sr PASSWORD

	install_dependencies

	install_ego_swarm

	echo "[STAR Lab] All installations completed successfully!"
}

main
