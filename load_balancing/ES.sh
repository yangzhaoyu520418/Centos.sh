#!/usr/bin/env bash
# author: yangzhaoyu time: 2019-09-04
# used: Provide the necessary functions

# To determine the user
rootNess(){
        echo "Detecting root users !!"
	[ ${UID} -eq 0 ] && echo "OK!!" && return 0  || return 1 && echo "You user is not root" && exit 1
}

# Yum installtion
yum_Ist(){
        echo "Start install system environmental science"
	if [ "$0" -eq "keepalived.sh"  ]; then
		yum -y install gcc gc gcc-c++ libnl* libpopt* libnfnetlink-devel openssl openssl-devel > /dev/null
		[ $? -eq 0 ] && echo "OK!!" && return 0 || return 1 && echo "You please installtion soft" && exit 1
	elif [ "$0" -eq "lvs.sh"  ]; then
        	yum -y install gcc gc gcc-c++ libnl* libpopt* popt-static popt-devel > /dev/null
        	[ $? -eq 0 ] && echo "OK!!" && return 0 || return 1 && echo "You please installtion soft" && exit 1
	elif [ "$0" -eq "haproxy.sh"   ]; then
		echo
		[ $? -eq 0 ] && echo "OK!!" && return 0 || return 1 && echo "You please installtion soft" && exit 1
	elif [ "$0" -eq "heartbeat.sh"  ]; then
		echo
		[ $? -eq 0 ] && echo "OK!!" && return 0 || return 1 && echo "You please installtion soft" && exit 1
	fi
}

#  Service adjustment
service_ad(){
        echo "Turn off unnecessary services !!"
        systemctl stop firewalld 2>&1 > /dev/null
        systemctl disable firewalld 2>&1 /dev/null
     	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config 2>&1 /dev/null
        cat >> /etc/sysctl.conf <<-EOF
        net.ipv4.ip_forward = 1
	EOF
        sysctl -p > /dev/null
        echo "OK!!"
}



