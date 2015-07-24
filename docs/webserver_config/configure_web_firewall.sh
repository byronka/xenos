#!/bin/bash
#
# iptables example configuration script
#
# Flush all current rules from iptables
#
 iptables -F
#
# Allow SSH connections on tcp port 22
# This is essential when working on remote servers via SSH to prevent locking yourself out of the system
#
 iptables -A INPUT -p tcp --dport 22 -j ACCEPT
 iptables -A INPUT -p tcp --dport 80 -j ACCEPT
 iptables -A INPUT -p tcp --dport 443 -j ACCEPT
#
# Set default policies for INPUT, FORWARD and OUTPUT chains
#
 iptables -P INPUT DROP
 iptables -P FORWARD DROP
 iptables -P OUTPUT ACCEPT
#
# Set access for localhost
#
 iptables -A INPUT -i lo -j ACCEPT
#
# Accept packets belonging to established and related connections
#
 iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


# allow ICMP Type 8 (ping, ICMP traceroute)
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
# enable UDP traceroute rejections to get sent out
iptables -A INPUT -p udp --dport 33434:33523 -j REJECT

# Following will enable logging of many dropped packets
#iptables -N LOGGING
#iptables -A INPUT -j LOGGING
#iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
#iptables -A LOGGING -j DROP
#
# Save settings
#
 /sbin/service iptables save
#
# List rules
#
 iptables -L -v

