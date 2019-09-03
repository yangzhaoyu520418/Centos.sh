#!/bin/bash
# author: yangzhaoyu time:2019-08-31
# used: keepalived installtion

# To determine the user
rootNess(){
	echo "Detecting root users !!"
	[ ${UID} -eq 0 ]  && echo "OK!!" &&return 0 || return 1 && echo "You user is not root" && exit 1
}

# Yum installtion
yum_Ist(){
	echo "Start install system environmental science"
	yum -y install gcc gc gcc-c++ libnl libnl-devel libnfnetlink-devel openssl openssl-devel > /dev/null
	[ $? -eq 0 ] && echo "OK!!" &&return 0 || return 1 && echo "You please installtion sort" && exit 1
}

# service adjustment
service_ad(){
	echo "Turn off unnecessary services !!"
	systemctl stop firewalld 2>&1 > /dev/null
	systemctl disable firewalld 2>&1 > /dev/null
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config 2>&1 /dev/null
	cat >> /etc/sysctl.conf <<-EOF
	net.ipv4.ip_forward = 1
	EOF
       	sysctl -p > /dev/null
	echo "OK!!"	
}

# Install the Keepakived
install_Keepalived(){
	echo "Start installation Keepalived"
	local KEEPALIVED_URL="https://www.keepalived.org/software/keepalived-2.0.18.tar.gz"
	local WGET_DIR="/usr/bin/wget" 
	local KEEPALIVED_DIR="/soft/keepalived"
	local KEEPALIVED_ETC="/etc/keepalived"
	local KEEP_DIR
	local KEEP_PREFIX="/usr/local/keepalived"
	[ -f ${WGET_DIR} ] || yum -y install wget >> /dev/null
	[ -d ${KEEPALIVED_DIR}  ] || mkdir -p ${KEEPALIVED_DIR}
	[ -d ${KEEPALIVED_ETC}  ] || mkdir -p ${KEEPALIVED_ETC}
	wget ${KEEPALIVED_URL} -P ${KEEPALIVED_DIR} >> /dev/null
	tar xf ${KEEPALIVED_DIR}/${KEEPALIVED_URL##*/} -C ${KEEPALIVED_DIR}/
	rm -rf ${KEEPALIVED_DIR}/${KEEPALIVED_URL##*/}
	KEEP_DIR=`ls ${KEEPALIVED_DIR}`
	cd ${KEEPALIVED_DIR}/${KEEP_DIR} ; ./configure --prefix=/usr/local/keepalived >> /dev/null ; make >> /dev/null && make install > /dev/null
	cp ${KEEPALIVED_DIR}/${KEEP_DIR}/keepalived/etc/init.d/keepalived /etc/init.d/
	cp /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/
	cp ${KEEPALIVED_DIR}/${KEEP_DIR}/keepalived/etc/sysconfig/keepalived /etc/sysconfig/keepalived
	[ $? -eq 0 ] && echo "The keepalive is installtion" || echo "The Keepalived is not installtion" && exit 1
}

rootNess
yum_Ist
service_ad
install_Keepalived

