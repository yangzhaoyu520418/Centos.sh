#!/bin/bash
# author: yangzhaoyu time:2019-08-31
# used: keepalived installtion

# To determine the user
rootNess(){
	[ ${UID} -eq 0 ]  && return 0 || return 1 && echo "You user is not root" && exit 1
}

# Yum installtion
yum_Ist(){
	yum -y install gcc gc gcc-c++ libnl libnl-devel libnfnetlink-devel openssl openssl-devel > /dev/null
	[ $? -eq 0 ] && return 0 || return 1 && echo "You please installtion sort" && exit 1
}

# service adjustment
service_ad(){
	systemctl stop firewalld 2>&1 > /dev/null
	systemctl disable firewalld 2>&1 > /dev/null
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config 2>&1 /dev/null
	cat >> /etc/sysctl.conf <<-EOF
	net.ipv4.ip_forward = 1
	EOF
       	sysctl -p > /dev/null	
}

# Install the Keepakived
install_Keepalived(){
	local KEEPALIVED_URL="https://www.keepalived.org/software/keepalived-2.0.18.tar.gz"
	local WGET_DIR="/usr/bin/wget" 
	local KEEPALIVED_DIR="/soft/keepalived
	local 

}
