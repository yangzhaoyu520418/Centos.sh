#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Download_dir=/nfs/
Download_logs_dir=/opt/log
Download_log_ok_name=Download_ok.log
Download_log_error_name=Download_error.log

rootness(){
	if [ "$EUID" -ne 0 ]; then
		echo "Please use root user"
		exit 1
	fi
}

Download_ufs(){
	local usf=`df-h | grep nfs| wc -l`
	if [ "$usf" -ne 0 ]; then
		return
	else
		exit 1
	fi
}

File_search(){
	local fn=`find / -name $name`
	if [  -n "fn" ]; then
		if [ -d "$Download_dir$Download_name" ]; then
			echo "\n"
		else
			mkdir -p $Download_dir$Download_name	
		fi
		mv $fn $Download_dir/$filename
	else
		exit 1
	fi
}

Download_logs(){
	if [ -d "$Download_logs_dir" ]; then
		echo "\n"
	else
		mkdir -p $Download_logs_dir
	fi
}

files_num(){
	local f=`cat $Download_dir$filename/$name | wc -l`
	echo $f
}

Download_mp4(){
while read line;do
        # Need Download name
        local a=`echo ${line} | awk -F'http' '{print $1}'`
        # Need Download address
        local b=`echo ${line} | awk -F'http' '{print $2}'`
        axel --num-connections=5 --output=$Download_dir$filename/$a  --alternate http$b                 
        if [ "$?" -gt 0 ]; then
                axel --num-connections=5 --output=$Download_dir$filename/$a --alternate http$b 
        fi
done < $Download_dir$filename/$name
}
read -p "Please need Download files name:" name
read -p "Please need Download Filename:" filename

rootness
Download_ufs
File_search
files_num
Download_logs
Download_mp4