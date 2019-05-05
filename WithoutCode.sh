#!/bin/bash
# author:yangzhaoyu  time:20190505
# Newly added users add private login
# In root use
# usage ./WithoutCode.sh usename
# usename == what you need to create, if username inexistence so create use and Create a private login 
# private login in /home/{user}/.ssh/ please to the person who created it


NAME=[`ls /home/ | tr '\n' ' '`]
USER="$1"

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

rootness(){
    if [[ ${EUID} -ne 0 ]]; then
       log "Error" "This script must be run as root"
       exit 1
    fi
}

getUserName(){
        local x
        for x in ${NAME[@]}; do
                if [ "${x}" == "${USER}" ]; then
                         echo "OK the user nonentity"
                         break 
                else
                        echo "NO the user exist"
                        echo "Check if there is a directory with private login"
                fi 
        done
        wait
        return 10
}

rootness
getUserName
