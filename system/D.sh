#!/usr/bin/env bash
# author: yangzhaoyu time: 2018-11-05
# Download files

TEMPFIFO=$$.fifo

trap "exec 1000>&-;exec 1000<&-;exit 0" 2

mkfifo ${TEMPFIFO}
exec 1000<>${TEMPFIFO}
rm -rf ${TEMPFIFO}

for ((i=1; i<=10; i++)) # 数字几就是几个进程 按量修改
do
    echo >&1000
done


while read line;do
read -u1000
{
    a=`echo "${line}" | awk -F'http' '{print $1}'|sed 's/[[:space:]]//g'`
    i=`echo "$a" |  awk -F'[/]+' '{print $4$5$6$7$8}'`
    b=`echo "${line}" | awk -F'http' '{print $2}'|sed 's/[[:space:]]//g'`
    c=`echo "${line}" | awk -F'/' '{print $2}'| sed 's/[[:space:]]//g'`
    d=`echo "${line}" | awk -F'/' '{print $3}'| sed 's/[[:space:]]//g'`
    #echo "/nfs/$c/$d/$i"
    if [ -f "/nfs/$c/$d/$i" ]; then
                echo "Space" 
    else
    if [ ! -d "/nfs/$c/$d" ]; then
                echo "/nfs/$c/$d" >> 2.txt
        mkdir -p /nfs/$c/$d
    fi
    axel -a -n 40 -o /nfs/$c/$d/$i "http${b}"
    #echo "/nfs/$c/$d/$i "http${b}"" >> 1.txt
    echo "Download"
    fi
    echo >&1000
        #if [ ! -f "/nfs/$c/$d/$i" ]; then
        #       if [ ! -d "/nfs/$c/$d" ]; then
        #               echo "/nfs/$c/$d" >> 2.txt
                        #mkdir -p /nfs/$c/$d 
        #       fi
                #axel -a -n 20 -o /nfs$c/$d/$i "http${b}"
        #       echo "/nfs/$c/$d/$i" >> 1.txt
        #else
        #       echo "Space" | tree 3.txt
        #fi
}&
done < $1
wait
