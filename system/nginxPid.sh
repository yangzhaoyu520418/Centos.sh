#!/bin/bash
# author: yangzhaoyu time: 2019-09-04
# used: nginxPid is or is not exist

while :; do
	nginxPidNumber=`ps -C nginx --no-header | wc -l`
	[ $nginxPidNumber -eq 0 ] && /usr/local/nginx/sbin/nginx -s reload
	sleep 5
	[ $nginxPidNumber -eq 0	] && /usr/local/nginx/sbin/nginx stop
sleep 5		
done
