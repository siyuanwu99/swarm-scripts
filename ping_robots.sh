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

# Initialize arrays
declare -a robot_names
declare -a robot_ips
declare -a robot_groups
declare -a working_ips
declare -a working_names
declare -a working_groups

# Extracting robot names, IPs, and groups
robot_names=()
robot_ips=()
robot_groups=()
if [ ! -f $YAML_FILE ]; then
	echo "File $YAML_FILE not found!"
	exit 1
else
	echo "Reading $YAML_FILE..."
	while IFS= read -r line; do
		if [[ $line =~ ^[[:space:]]*\-[[:space:]]name: ]]; then
			robot_names+=("$(echo $line | sed 's/.*name: //')")
		elif [[ $line =~ ^[[:space:]]*ip: ]]; then
			robot_ips+=("$(echo $line | sed 's/.*ip: //')")
		elif [[ $line =~ ^[[:space:]]*sensor: ]]; then
			robot_groups+=("$(echo $line | sed 's/.*sensor: //')")
		fi
	done <"$YAML_FILE"
fi

# Length of the array
length=${#robot_ips[@]}
echo "Found $length IPs in $YAML_FILE"

# Exit if no IP is found
if [ $length -eq 0 ]; then
	echo "No IP found in $YAML_FILE"
	exit 1
fi

# Remove the temporary file if it exists
if [ -f $TEMP_FILE ]; then
	rm $TEMP_FILE
fi

# Ping each robot and save working ones
working_ips=()
working_names=()
working_groups=()
for ((i = 0; i < length; i++)); do
	name=${robot_names[$i]}
	ip=${robot_ips[$i]}
	group=${robot_groups[$i]}

	echo "Pinging $name with IP $ip..."

	if ping -c 1 $ip &>/dev/null; then
		echo ">> | $name is reachable."
		working_ips+=("$ip")
		working_names+=("$name")
		working_groups+=("$group")
		# Save to a temporary file
		echo "$name,$ip,$group" >>$TEMP_FILE
	else
		echo "$name with IP $ip is not reachable."
	fi
done
