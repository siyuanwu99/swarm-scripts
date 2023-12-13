#!/bin/bash

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

echo "Set $CON_NAME to static IP: $CUR_IP, Gateway: $CUR_GATEWAY, DNS: $CUR_DNS"
