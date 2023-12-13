#!/bin/bash

# Exit on any error
set -e

# Variables
PASSWORD=nv
CURRENT_USER=$(logname)
USER_HOME="/home/$CURRENT_USER"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
RACER_WS_DIR="$USER_HOME/star_exploration_ws/"
TMP_DIR="$USER_HOME/install_lkh"

# Function to update github code
update_racer() {
	echo "[STAR Lab] Update project..."

	# Navigate to the workspace directory, create src directory if not exist
	cd "$RACER_WS_DIR/src/swarm_exploration_project/"

    if [ ! -d ".git" ]; then
        echo "Error: Current directory is not a Git repository!"
        exit 1
    fi

	# Clone the required git repository
	git fetch origin
  git reset --hard origin/project
	
	cd ../..

	# Build the project
	catkin_make

	echo "[STAR Lab] RACER has been successfully installed!"

}

check_installation() {

    declare -a packages=("ros-noetic-tf2" "ros-noetic-tf2-ros" "ros-noetic-tf2" "ros-noetic-tf2-eigen")

    for pkg in "${packages[@]}"; do
        # Check if the package is installed
        dpkg -l | grep $pkg > /dev/null

        # $? is a special variable that captures the exit status of the last command executed
        if [ $? -ne 0 ]; then
        echo "$pkg is not installed. Installing..."
            sudo apt-get update
            sudo apt-get install $pkg
        else
            echo "$pkg is already installed."
        fi
    done
}

sync_configs() {
    cp ./.vimrc ~/.vimrc
	cp ./.tmux.conf.local ~/.tmux.conf.local
	cp ./setup.zsh $RACER_WS_DIR
}



# Main execution
main() {
	echo "Please enter your password: "

	read -sr PASSWORD

    check_installation

	update_racer

	echo "[STAR Lab] All update completed successfully!"
}

main
