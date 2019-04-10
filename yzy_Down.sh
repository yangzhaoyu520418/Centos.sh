#!/bin/bash
# Author for yangzhaoyu
# Wirted 2018.11.25
# Use Download video


PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Badminton_dir=/nfs/羽毛球
Basketball_dir=/nfs/篮球
Table_tennis_dir=/nfs/乒乓球
CBA_dir=/nfs/CBA
Billiards_dir=/nfs/台球
Strike_dir=/nfs/搏击
Rest_dir=/nfs/其他
files=`ls *.txt >> filename`
arr_sports=($Badminton_dir $Basketball_dir $Table_tennis_dir $CBA_dir $Billiards_dir $Strike_dir $Rest_dir)

exist_dictionary(){
        [ -d "$Badminton_dir" ] || mkdir -p /nfs/羽毛球 && echo "/nfs/羽毛球 create successful"
        [ -d "$Basketball_dir" ] || mkdir -p /nfs/篮球 && echo "/nfs/篮球 create successful"
        [ -d "$Table_tennis_dir" ] || mkdir -p /nfs/乒乓球 && echo "/nfs/乒乓球 create successful"
        [ -d "$CBA_dir" ] || mkdir -p /nfs/CBA && echo "/nfs/CBA create successful"
        [ -d "$Billiards_dir" ] || mkdir -p /nfs/台球 && echo "/nfs/台球 create successful"
        [ -d "$Strike_dir" ] || mkdir -p /nfs/搏击 && echo "/nfs/搏击 create successful"
        [ -d "$Rest_dir" ] || mkdir -p /nfs/其他 && echo "/nfs/其他 crate successful"
}

#dictionary_files(){
#        while read line; do
#               dos2unix $line
#                iconv -f utf8 -t gbk  $line > $line          
#        done < filename
#}

Download_SCEA(){
        while read line;do
                local a=`echo "${line}" | awk -F'http' '{print $1}'|sed 's/[[:space:]]//g'`
                #local i=`echo "$a" | sed "s/^[/]*//g"`
                local b=`echo "${line}" | awk -F'http' '{print $2}'|sed 's/[[:space:]]//g'`
                local c=`echo "${line}" | awk -F'/' '{print $2}'` 
                if [ "$1" == "羽毛球.txt" ] ;then
                        if [ -d "$c" ]; then
                                echo "OK"
                        else
                                mkdir -p ${arr_sports[0]}/$c
                        fi
                        axel -a -n 10 -o ${arr_sports[0]}/$a "http${b}"
                elif [ "$1" == "篮球.txt" ]; then
                        if [ -d "$c" ]; then
                                echo "OK"
                        else
                                mkdir -p ${arr_sports[1]}/$c
                        fi
                        axel -a -n 10 -o ${arr_sports[1]}/$a "http${b}"
                elif [ "$1" == "乒乓球.txt" ]; then
                        if [ -d "$c" ]; then
                                echo "OK"
                        else
                                mkdir ${arr_sports[2]}/${c}
                        fi
                        axel -a -n 10 -o -p ${arr_sports[2]}/${a} "http${b}"
                elif [ "$1" == "CBA.txt" ]; then
                        if [ -d "$c" ]; then
                                echo "OK"
                        else
                                mkdir -p ${arr_sports[3]}/$c
                        fi
                        axel -a -n 10 -o ${arr_sports[3]}/$a "http${b}"
                elif [ "$1" == "台球.txt" ]; then 
                        if [ -d "$c" ]; then
                                echo "OK"
                        else
                                mkdir -p ${arr_sports[4]}/$c
                        fi
                        axel -a -n 10 -o ${arr_sports[4]}/$a "http${b}"
                elif [ "$1" == "搏击.txt" ]; then
                        if [ -d "$c" ]; then
                                echo "OK"
                        else
                                mkdir -p ${arr_sports[5]}/$c
                        fi
                        axel -a -n 10 -o ${arr_sports[5]}/$a "http${b}"
                elif [ "$1" == "其他.txt" ]; then
                        if [ -d "$c" ]; then
                                echo "OK"
                        else
                                mkdir -p ${arr_sports[6]}/$c
                        fi
                        axel -a -n 10 -o ${arr_sports[6]}/$a "http${b}"
                fi
        done < $1
}

exist_dictionary
while read line; do
        Download_SCEA $line
done < filename

rm -rf filename
