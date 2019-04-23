#!/bin/bash

VIP=172.16.3.140
RIP1=172.16.3.133
RIP2=172.16.3.134
. /etc/rc.d/init.d/functions

logger $0 called with $1
case "$1" in
	start)
		echo "Start LVS of DirectorServer"
		ifconfig ens36:0 $VIP broadcast $VIP netmask 255.255.255.255
		route add -host $VIP dev ens36:0
		echo "1" > /proc/sys/net/ipv4/ip_forward
		ipvsadm -C
		ipvsadm -A -t $VIP:80 -s wrr -p 120
		ipvsadm -a -t $VIP:80 -r $RIP1:80 -g
		ipvsadm -a -t $VIP:80 -r $RIP2:80 -g
		ipvsadm
		;;
	stop)
		echo "close LVS Directorserver"
		echo "0" > /proc/sys/net/ipv4/ip_forward
		ipvsadm -C
		ifconfig ens36:0 down
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
esac

