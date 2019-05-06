#!/bin/bash
# author:yangzhaoyu  time:20190505
# Newly added users add private login
# In root use
# usage ./WithoutCode.sh username
# usename == what you need to create, if username inexistence so create use and Create a private login 
# private login in /home/{user}/.ssh/ please to the person who created it

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

NAME=[`ls /home/ | tr '\n' ' '`]
NAMENUMBER=${#NAME[@]}
GROUP=[`cat /etc/group | awk -F":" '{print $1}' | tr '\n' ' '`]
#PARAMETER="$1"

rootNess(){
    if [[ ${EUID} -ne 0 ]]; then
       log "Error" "This script must be run as root"
       exit 1
    fi
}

userVersion(){
        echo "Version:0.1"
}

#addUserHelp(){

#}

existUserName(){
        if test -z "$1"; then
                 USER=" "
                 echo "User name is not null !"
                 echo "please ./WithoutCode.sh username"
                 exit 1
        else
                 USER="$1"
        fi
        echo "${NAME[@]}" | grep -wq "${USER}" &&  return 0 || return 1
}

createUserName(){
        echo "Create User username:${USER} filedir:/home/${user}"
        useradd -g Develop ${USER} 
}

addKeyUsers(){
		local USER=$1
        local y
        for y in "${NAME[@]}"; do
                [ -f "/home/${USER}/.ssh/id_rsa" ] && [ -f "/home/${USER}/.ssh/id_rsa.pub" ] && echo "The $USER has key" 
        done
}

createUserSsh(){
        read -sp "please keypasswd:" KEYPASSWD
        while :;do
                [  -n "$KEYPASSWD"  ] && echo "Starting create secret key" &&  su ${USER} -c "ssh-keygen -t rsa -P '$KEYPASSWD' -f ~/.ssh/id_rsa > /dev/null"  && echo "OK!!" && break  ||  {
                read -p "please keypasswd is not null please input again:" KEYPASSWD && continue
                }
        done
		exit
                
}



createuserssh_main(){
        if [ "$?" == 0 ]; then
                echo "Please replace the user that needs to be created !!!"
                exit 1
        else
                echo "Starting create username"
                createUserName
                createUserSsh
                echo "SUCCEEDFUL!!"
        fi
}

createuser_main(){
        if [ "$?" == 0 ]; then
                echo "Please replace the user that needs to be created !!!"
                exit 1
        else
                echo "Starting create username"
                creatUserName
                echo "SUCCEEDFUL!!"
        fi
}

createssh_main(){
		existUserName $1
		if [ "$?" == 0 ]; then
			echo "ok The user is exist"
		else
			echo "The user is not exist"
			exit 1
		fi
		addKeyUsers $1
		createUserSsh
}

rootNess
while [[ $# -gt 0 ]]; do
        case "$1" in
        -h|--help)
                addUserHelp
                exit 1
                ;;
        -v|--version)
                userVersion
                exit 1
                ;;
        -c|--createuserssh)
                shift
                existUserName $1
                createuserssh_main 
                ;;
        -d|--deleteuserssh)
                shift
                ;;
        -G|--creategroup)
                shift
                ;;
        -S|--createssh)
				shift
                createssh_main $1
                ;;
        -U|--useradd)
                shift
                existUserName $1
                createuser_main
                ;;
        *)
                echo "Unknow argument: $1"
                exit 1
                ;;
        esac
shift
done