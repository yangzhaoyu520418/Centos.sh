#!/bin/bash
# author by yangzhaoyu 2018.11.12
# The script for installation LAMP 

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cur_dir=`pwd`

include(){
	local include=${1}
	if [[ -s ${cur_dir}/include/${include}.sh ]]; then
		. ${cur_dir}/include/${include}.sh
	else 
		echo "Error:${cur_dir}/include/${include}.sh not found, shell can not be executed"
	fi	
}

LAMP(){
	include config
	include public
	include apache
	include mysql
	include php
	include php-modules

	rootness
	load_config
	pre_setting
}

#lamp 2>&1 | tee ${cur_dir}/lamp.log
