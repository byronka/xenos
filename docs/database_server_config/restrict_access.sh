#!/bin/bash
# This script will configure iptables to restrict access to solely
# the www box - that is, the box with the tomcat web server on it.
#
# Flush all current rules from iptables
#
iptables -F

# Allow existing connections to continue
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -I INPUT -s 198.23.161.154 -j ACCEPT #the other database server
iptables -I INPUT -s 198.23.128.117 -j ACCEPT #the web server
iptables -I INPUT -s 23.95.35.84 -j ACCEPT #the old web server
iptables -A INPUT -i lo -j ACCEPT
iptables -P INPUT DROP

# Save settings
#
/sbin/service iptables save
# List rules
#
iptables -L -v

