#!/bin/bash
# Time: 2019-04-15 Author:yangzhaoyu
# Use:git push self-motion

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

COUNT=${#}

# use root start script
rootNess(){
    if [[ ${EUID} -ne 0 ]]; then
       log "Error" "This script must be run as root"
       exit 1
    fi
}

rootNess

echo "Start update git (use git push)"
#echo "${COUNT}"
if [ ${COUNT} -ge 3 ]; then
shift 1
	echo "$@"
	for flat in $@; do
		echo "is :$flat"
	#	git add ${flat} 		
	done
else
	echo  "$1"
fi

 
