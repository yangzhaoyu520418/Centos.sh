#!/bin/bash
# author for yangzhaoyu 2018.11.8
# use: backup system files

#
backup_dir=/home/backup/
backup_data=/home/yzy
root_home=/home
date_now=$(date +%Y%m%d)
tar_name=yzy$date_now\.tar
xz_tar=`find /home/backup/  -name *.xz |wc -l`  
xz_dir=`find /home/backup/  -name *.xz`
if [ $xz_tar == 1 ];then
	rm -rf $xz_dir
    	tar cf $root_home/$tar_name $backup_data 2&>/dev/null
    	mv $root_home/$tar_name $backup_dir
    	cd  $backup_dir
    	xz -z -9 $tar_name
elif [ $xz_tar == 0  ];then
    	tar cf $root_home/$tar_name $backup_data 2&>/dev/null
    	mv $root_home/$tar_name $backup_dir
   	    cd  $backup_dir
    	xz -z -9 $tar_name
else
   exit    
fi
