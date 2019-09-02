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
	local KEEPALIVED_DIR="/soft/keepalived"
	local KEEPALIVED_ETC="/etc/keepalived"
	[ -f ${WGET_DIR} ] || yum -y install wget >> /dev/null
	[ -d ${KEEPALIVED_DIR}  ] || mkdir -p ${KEEPALIVED_DIR}
	wget ${KEEPALIVED_URL} -p ${KEEPALIVED_DIR}
	tar xf ${KEEPALIVED_DIR}/${KEEPALIVED_URL##*/} -C ${KEEPALIVED_DIR}/
	rm -rf ${KEEPALIVED_DIR}/${KEEPALIVED_URL##*/}
	KEEP_DIR=`ls ${KEEPALIVED_DIR}`
	cd ${KEEPALIVED_DIR}/${KEEP_DIR} ; ./configure --prefix=/usr/local/keepalived ; make && make install
	cp ${KEEPALIVED_DIR}/${KEEP_DIR}/keepalived/etc/init.d/keepalived /etc/init.d/
	cp /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/
	cp ${KEEPALIVED_DIR}/${KEEP_DIR}/keepalived/etc/sysconfig/keepalived /etc/sysconfig/keepalived
	[ $? -eq 0 ] && echo "The keepalive is installtion" || echo "The Keepalived is not installtion" && exit 1
}

rootNess
yum_Ist
service_ad
install_Keepalived

