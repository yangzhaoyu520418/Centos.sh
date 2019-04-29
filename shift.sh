#!/bin/bash 

for i in `seq 1 101`;do
{
	curl http://shop.zhibo.tv > /dev/null 2>&1
	#sleep 3
	echo "start"
}&
done
wait
