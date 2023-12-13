#!/bin/bash

PASSWORD=nv
CURRENT_USER=$(logname)
USER_HOME="/home/$CURRENT_USER"

# Function to copy configurations to home directory
copy_configs() {
	echo "[SYSU-STAR] Copying configurations to home directory..."
	[ ! -f ~/.vimrc ] && cp ./.vimrc ~/.vimrc
	cp ./.tmux.conf ~/.tmux.conf
	cp ./.tmux.conf.local ~/.tmux.conf.local
	cp .ssh/* ~/.ssh/
	# [ ! -f ~/.tmux ] && cp .tmux ~/.tmux -r
  sudo chmod 0600 ~/.ssh/id_rsa
  sudo chmod 0644 ~/.ssh/id_rsa.pub
	echo "[SYSU-STAR] Configurations copied!"
}

install_tmux() {
	echo "[SYSU-STAR] Installing tmux..."

	echo $PASSWORD | sudo -S apt-get install -y tmux 

	# install oh-my-tmux
	cp ./.tmux.conf ~/.tmux.conf
	cp ./.tmux.conf.local ~/.tmux.conf.local

	# install tpm and necessary plugins
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 
	git clone https://github.com/tmux-plugins/tmux-cpu ~/.tmux/plugins/tmux-cpu

	echo "[SYSU-STAR] tmux installed!"
}

# Function to set static IP address
set_static_ip() {
	echo "[SYSU-STAR] Setting static IP address..."
	# Get the connection name
	CON_NAME=$(nmcli con show --active | awk 'NR==2 {print $1}')

	# Get the current IP address, gateway, and DNS allocated by DHCP
	CUR_IP=$(nmcli con show "$CON_NAME" | grep 'IP4.ADDRESS' | awk '{print $2}')
	CUR_GATEWAY=$(nmcli con show "$CON_NAME" | grep 'IP4.GATEWAY' | awk '{print $2}')
	CUR_DNS=$(nmcli con show "$CON_NAME" | grep 'IP4.DNS' | awk '{print $2}')

	# Set the IP address, gateway, and DNS to static using their current values
	sudo nmcli con mod "$CON_NAME" ipv4.addresses "$CUR_IP" ipv4.gateway "$CUR_GATEWAY" ipv4.dns "$CUR_DNS" ipv4.method manual

	# Restart NetworkManager to apply changes
	sudo systemctl restart NetworkManager

	echo "[SYSU-STAR] Set $CON_NAME to static IP: $CUR_IP, Gateway: $CUR_GATEWAY, DNS: $CUR_DNS"
}

install_dependencies() {
	echo "[SYSU-STAR] Installing dependencies..."
	# echo $password | sudo -S apt-get update -y

	# Install system dependencies
	echo $PASSWORD | sudo -S apt-get install -y ssh tmux python3-pip iperf iftop python3-rosdep jq

	# install jtop
	echo $PASSWORD | sudo -S pip3 install jetson-stats

	# Install other dependencies
	echo $PASSWORD | sudo -S apt-get install -y libglfw3-dev libglew-dev libzmqpp-dev

	echo "[SYSU-STAR] Dependencies installed!"
}

# Function to add configurations to .zshrc
customize_zshrc() {
	echo "[SYSU-STAR] Customizing .zshrc..."

	# Path to the .zshrc file
	ZSHRC="$USER_HOME/.zshrc"

	# Check if .zshrc exists, create if not
	[ ! -f "$ZSHRC" ] && touch "$ZSHRC"
	# Append configurations
	{
		echo "# Custom configurations added by install.sh"
		echo "alias shutdown=\"sudo shutdown now\""
		echo "alias vis=\"rosrun vins vins_node /home/nv/swarm_exploration_ws/src/real_utils/VINS-Fusion-gpu/config/px4/stereo_imu_config.yaml\""
		echo "alias mav=\"sudo chmod 777 /dev/tty* && roslaunch mavros px4.launch\""
		echo "alias cam=\"roslaunch realsense2_camera rs_camera.launch\""
		# echo "export MY_VARIABLE=\"some_value\""
	} >>"$ZSHRC"

	echo "[SYSU-STAR] Configurations added to .zshrc"
}

# Main execution
main() {
    
	echo "Please enter your password: "

	read -sr PASSWORD

	copy_configs
	install_dependencies
	install_tmux
   # customize_zshrc
	# set_static_ip
    # customize_zshrc
	echo "[SYSU-STAR] Installation complete!"
}

main
