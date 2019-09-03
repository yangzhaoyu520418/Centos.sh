#!/bin/bash

while :; do
	nginxPidNumber=`ps -C nginx --no-header | wc -l`
	[ $nginxPidNumber -eq 0 ] && /usr/local/nginx/sbin/nginx -s reload
	sleep 5
	[ $nginxPidNumber -eq 0	] && /usr/local/nginx/sbin/nginx stop
sleep 5		
done
