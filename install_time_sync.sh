#!/usr/bin/bash
# Exit on any error
set -e

# Variables
PASSWORD=
CURRENT_USER=$(logname)
CLIENT_USER=nv
CLIENT_IP=192.168.2.158

# Function to install ROS and other dependencies
install_dependencies() {
	echo PASSWORD | sudo -S apt-get install ntp nptdate chrony -y:
	ssh -t $CLIENT_USER@$CLIENT_IP "echo $PASSWORD | sudo -S apt-get install ntp nptdate -y"

}

setup_ntpserver() {
	echo "Setting up NTP server..."
	IP=$(hostname -I | awk '{print $1}')    # 192.168.2.112
	IP_PREFIX=$(echo $IP | cut -d'.' -f1-3) # 192.168.2

	echo "restrict $IP_PREFIX.0 mask 255.255.255.0 nomodify notrap" | sudo tee -a /etc/ntp.conf
	echo "server 127.127.1.0" | sudo tee -a /etc/ntp.conf
	echo "fudge 127.127.1.0 stratum 10" | sudo tee -a /etc/ntp.conf

}

# Main execution
main() {
	echo "Please enter your password: "

	read -sr PASSWORD

	install_dependencies

	sudo /etc/init.d/ntp restart
	sudo /etc/init.d/ntp status

	echo "[STAR Lab] All installations completed successfully!"

}

main
