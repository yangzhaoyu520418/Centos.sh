#!/bin/bash
# author as yangzhaoyu 2018.11.14
# use LAMP public

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'

log(){
	if   [ "${1}" == "Warning" ]; then
		echo -e "[${YELLOW}${1}${PLAIN}]${2}"
	elif [ "${1}" == "Error" ]; then
		echo -e "[${RED}${1}${PLATN}]${2}"
	elif [ "${1}" == "INFO" ]; then
		echo -e "[${GREEN}${1}${PLATN}]${2}"
	else	
		echo -e "[${1}] ${2}"	
	if 	
}

rootness(){
	if [[ ${EUID} -ne 0 ]]; then
		log "Error" "This script must be run as root"
		exit 1
	fi
}

git_ip(){
	local IP=`ip addr  | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'| egrep -v "^192\.168|^172\.1[6-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1` 
	[ -z ${IP} ] && IP=`wget -qO -t1 -T2 ipv4.icanhazip.com`
	[ -z ${IP} ] && IP=`wget -qO -t1 -T2 ipinfo.io/ip`
	[ ! -z ${IP} ] && echo ${IP}|| echo 
}

