#!/bin/bash 

for i in `seq 1 101`;do
{
	curl  > /dev/null 2>&1
	#sleep 3
	echo "start"
}&
done
wait
