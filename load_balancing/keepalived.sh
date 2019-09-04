#!/bin/bash
# author: yangzhaoyu time:2019-08-31
# used: keepalived installtion

# Calling environment functions
. ./ES.sh

# Install the Keepakived
install_Keepalived(){
	echo "Start installation Keepalived"
	local KEEPALIVED_URL="https://www.keepalived.org/software/keepalived-2.0.18.tar.gz"
	local KEEPALIVED_DIR="/soft/keepalived"
	local KEEPALIVED_ETC="/etc/keepalived"
	local KEEP_DIR
	local KEEP_PREFIX="/usr/local/keepalived"
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
yum_Ist $0
service_ad
install_Keepalived

