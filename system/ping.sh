#!/usr/bin/env bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'

# To determine the user
rootness(){
    if [[ ${EUID} -ne 0 ]]; then
       log "Error" "This script must be run as root"
       exit 1
    fi
}

# Determine if the IP address is correct
IP_ADDRESS_change(){
    local IP=$1   
    VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')   
    if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" >/dev/null; then   
        if [ "$VALID_CHECK" == "yes" ]; then   
         echo "IP $IP  available!"   
            return 0   
        else   
            echo "IP $IP not available!"   
            return 1   
        fi   
    else   
        echo "IP format error!"   
        return 1   
    fi
}

# Where log files are stored
logs_ping(){
	if [ ! -d "$log_dir_logs" ]; then
		mkdir -p /opt/ping_logs
	else
		return
	fi
}

# Email function
ping_email(){
	local array=() # E-mail address
	for i in ${array[@]};do
		if (( "$awk_time" == 0 )); then
			echo " error:Check the network if it is disconnected!!! " | mail -s "network error" $i
		else 
			echo "log_files_size=$type_size time=$awk_time errorNetwork latency higher than 10 is less than 50, please note " | mail -s "network error" $i
		fi		
	done
}

# Show Current CPU Usage
CPU_utilization(){

}

# Memory usage
Memory_utilization(){
	
}

#File detection
ping_file(){
	local type_size=`du -h $log_dir_logs| awk -F'K' '{print $1}'`
	local ping_log_files=`find $log_dir_logs -mtime +15 -name "*.log" -exec rm -rf {} \;` 2&>1 /dev/null
	
}

# ping function
ping_command(){
	local log_dir_logs=/opt/ping_logs
	local log_ok=`date +%Y%m%d`_ok.log
	local log_error=`date +%Y%m%d`_error.log
	while true; do
		local date=`date +%F%T`
		local date1=`date +%Y%m$d`
        local awk=`ping $IP -c 1| awk -F':' 'NR == 2 {print $2}'`
        local awk_time=`ping $IP -c 1|awk -F"[ =]" '/bytes from/ {print $10}'| xargs printf "%.0f\n"`
      	local type_size=`du -h $log_dir_logs| awk -F'K' '{print $1}'`
      	if (( "$awk_time" == 0 )); then
            #echo -e "$date $IP Network connectivity" >> $log_dir_logs/$IP\ $log_error
            echo -e "${RED}$date $IP Network connectivity${PLAIN}" >> $log_dir_logs/$IP\ $log_error &&  echo -e "${RED}$date $IP Network connectivity log_szie=$type_size ${PLAIN}"
            ping_email
        else
        	if (( "$awk_time"  <= 10 )); then
        		echo -e "${GREEN}$date $IP time=$awk_time ms${PLAIN}" >> $log_dir_logs/$IP\ $log_ok &&  echo -e "${GREEN}$date $IP time=$awk_time ms log_szie=$type_size${PLAIN}" && return 0
       		elif (( "$awk_time" > 10 )) && (( "$awk_time" <= 50 )); then
       			echo -e "${YELLOW}$date $IP time=$awk_time ms${PLAIN}" >> $log_dir_logs/$IP\ $log_ok && echo -e "${YELLOW}$date $IP time=$awk_time ms log_szie=$type_size${PLAIN}" && return 1
        	elif (( "$awk_time"  > 50 )); then
        		echo -e "${RED}$date $IP time=$awk_time ms${PLAIN}" >> $log_dir_logs/$IP\ $log_ok && echo -e "${RED}$date $IP time=$awk_time ms log_szie=$type_size${PLAIN}" && return 2
        		ping_email
        	fi
        fi
        sleep 1
	done        
}


# Cycle judgment
while true; do
   read -p "Please input the ip:" IP
   IP_ADDRESS_change $IP
   [[ $? -eq 0 ]] && break
done

# invoking function
rootness
logs_ping
ping_command
