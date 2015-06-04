#!/bin/bash 
#
#Author: Tyler Hall
#Title: Iptables configuration
###################
#notes:
##Accept packets from trusted IP addresses
##iptables -A INPUT -s 192.168.0.4 -j ACCEPT # change the IP address as appropriate
##iptables -A INPUT -s 192.168.0.0/24 -j ACCEPT  # using standard slash notation
##iptables -A INPUT -s 192.168.0.0/255.255.255.0 -j ACCEPT # using a subnet mask
#temporarily set default policy on input chain to accept
echo "Temporarily allowing all connections by default"
iptables -P INPUT ACCEPT
# iptables example configuration script
#
# Flush all current rules from iptables
echo "Flush current rules..."
iptables -F

#Allow SSH connections on tcp port 22 so we don't get locked out
echo "Allowing connection to port 22 for ssh"
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

while true; do
    read -p "Is this machine being used as a router?" yn
    case $yn in
        [Yy]* ) echo "Accepting all FORWARD packets" && iptables -P FORWARD ACCEPT;;
        [Nn]* ) echo "Dropping all Forward Packets by default" && iptables -P FORWARD DROP;;
        * ) echo "Dropping all FORWARD by default" && iptables -P FORWARD DROP;;
    esac
done

iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT

#Loop over all command line arguements
for port in "$@"
do
  echo "Opening port $port"
  iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
done

#logs any dropped packages to /var/log/messages
iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
iptables -A LOGGING -j DROP

# Outbound UDP Flood protection in a user defined chain.
iptables -N udp-flood
iptables -A OUTPUT -p udp -j udp-flood
iptables -A udp-flood -p udp -m limit --limit 50/s -j RETURN
iptables -A udp-flood -j LOG --log-level 4 --log-prefix 'UDP-flood attempt: '
iptables -A udp-flood -j DROP

# Save settings
 /sbin/service iptables save
# List rules
 iptables -L -v
