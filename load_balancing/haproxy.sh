#!/usr/bin/env bash
# author: yangzhaoyu time:2019-09-03
# used: haproxy installtion

# Calling environment functions
. ./ES.sh

# HA conf
ha_conf(){
	cat >> ${HA_SYSTEM_DIR} <<-EOF
	[Unit]
	Description=HAProxy
	After=network.target

	[Service]
	User=root
	Type=forking
	ExecStart=/usr/local/haproxy/sbin/haproxy -f /usr/local/haproxy/conf/haproxy.cfg
	ExecStop=/usr/bin/kill `/usr/bin/cat /usr/local/haproxy/haproxy.pid`

	[Install]
	WantedBy=multi-user.target
	EOF
}

# HA haproxy.cfg 
ha_cfg(){
	cat >> ${HA_CFG} <<-EOF
	global
        	daemon
        	maxconn 4000
        	pidfile /usr/local/haproxy/haproxy.pid

	defaults
        	timeout connect 10s
        	timeout client 1m
        	timeout server 1m

	listen app
        	bind 0.0.0.0:8080
        	mode tcp
        	server app001 app001.domain.com:8080 check
        	server app002 app002.domain.com:8080 check

	listen haproxy_statistics
        	bind 0.0.0.0:9000
        	mode http
        	stats enable
        	stats uri /haproxy_statistics
        	stats realm HAProxy\ Statistics
        	stats auth admin:Password
	EOF
}

# Install the HAPROXY
install_Haproxy(){
        echo "Start installation HAPROXY"
	local HA_URL="http://www.haproxy.org/download/2.0/src/haproxy-2.0.5.tar.gz"
	local HA_DIR="/soft/haproxy"
	local HA_CONF="/usr/local/haproxy/conf"
	local HA_TAR_DIR=`ls ${HA_DIR}`
	local HA_SYSTEM_DIR="/usr/lib/systemd/system/haproxy.service"
	local HA_CFG="/usr/local/haproxy/conf/haproxy.cfg"
	[ -d ${HA_DIR} ] || mkdir -p ${HA_DIR}
	wget -P ${HA_DIR} ${HA_DIR}
	tar xf ${HA_DIR}/${HA_URL##*/} -C ${HA_DIR}
	rm -rf ${HA_DIR}/${HA_URL##*/}
	cd ${HA_DIR}/${HA_TAR_DIR}; make TARGET=generic PREFIX=/usr/local/haproxy > /dev/null ; make install PREFIX=/usr/local/haproxy > /dev/null
	[ $? -eq 0 ] && echo "The haproxy is installrion" || echo "The haproxy is not installtion" && exit 1
	mkdir -p ${HA_CONF} ; touch ${HA_SYSTEM_DIR} ; touch ${HA_CFG}
	ha_conf 
	ha_cfg
}

rootNess
yum_Ist $0
service_ad
install_Haproxy

