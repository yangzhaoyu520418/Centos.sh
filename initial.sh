#!/bin/bash

VIP=192.168.10.10
RIP1=192.168.10.170
RIP2=192.168.10.171
. /etc/rc.d/init.d/functions

logger $0 called with $1
case "$1" in
	start)
		echo "Start LVS of DirectorServer"
		ifconfig ens3e:0 $VIP broadcast $VIP netmask 255.255.255.255 up
		route add -host $VIP dev ens33:0
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
		ifconfig ens33:0 down
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
esac

