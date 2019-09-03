#!/bin/bash
# author:yangzhaoyu  time:20190505
# Newly added users add private login
# In root use
# usename == what you need to create, if username inexistence so create use and Create a private login 
# private login in /home/{user}/.ssh/ please to the person who created it

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

NAME=[`ls /home/ | tr '\n' ' '`]
NAMENUMBER=${#NAME[@]}
GROUP=[`cat /etc/group | awk -F":" '{print $1}' | tr '\n' ' '`]
#PARAMETER="$1"

# 使用方法
addUserHelp(){
		echo "./WithoutCode.sh --help| -h "
		echo "./WithoutCode.sh --version | -v"
		echo "./WithoutCode.sh --createuserssh|-c"
		echo "./WithoutCode.sh --deleteuserssh|-d"
		#echo "./WithoutCode.sh --creategroup|-G"
		#echo "./WithoutCode.sh --delgroup|-g"
		echo "./WithoutCode.sh --createssh|-S"
		echo "./WithoutCode.sh --useradd|-U"
}

# root用户使用
rootNess(){
    if [[ ${EUID} -ne 0 ]]; then
       log "Error" "This script must be run as root"
       exit 1
    fi
}

# 版本号
userVersion(){
        echo "Version:0.2"
}

# 名字是否存在
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

# 创建用户
createUserName(){
    echo "Create User username:${USER} filedir:/home/${USER}"
    useradd -g Develop ${USER}  
}

# 添加密钥
addKeyUsers(){
	local USER=$1
    	[ -f "/home/${USER}/.ssh/${USER}" ] && [ -f "/home/${USER}/.ssh/${USER}.pub" ]  && return 0 || return 1 
}

# 创建KEY密码
createUserSsh(){
    read -sp "please keypasswd:" KEYPASSWD
    echo
    read -sp "Please input Keypasswd again:" AGKEYPASSWD
    echo
    while :;do 
        [  -n "${KEYPASSWD}"  ]  || {
		echo "please keypasswd is not null"  &&  read -rsp "please keypasswd:" KEYPASSWD && echo && read -rsp "Please input Keypasswd again:" AGKEYPASSWD && echo && continue 
	}
	[ -n "${AGKEYPASSWD}" ] || {
		echo "please again Keypasswd is not null"  &&  read -sp "please keypasswd:" KEYPASSWD && echo && read -sp "Please input Keypasswd again:" AGKEYPASSWD && echo && continue 
	}	
       	[ "${KEYPASSWD}" == "${AGKEYPASSWD}"  ] || {
		echo "If there is a mistake in the password entered twice, please re-enter it." && read -sp "please keypasswd:" KEYPASSWD && echo  && read -sp "Please input Keypasswd again:" AGKEYPASSWD && echo && continue
	}
       	echo "Starting create secret key" &&  su ${USER} -c "ssh-keygen -t rsa -P '$KEYPASSWD' -f ~/.ssh/${USER} > /dev/null && cat ~/.ssh/${USER}.pub > ~/.ssh/authorized_keys"  && echo "OK!!" && break   
    done
    exit 1
}

# 删除用户
delUserSsh(){
	local USER=$1
	local PASSWD=[`cat /etc/group | awk -F":" '{print $1}' | tr '\n' ' '`]
	echo "${PASSWD[@]}" | grep -wq "${USER}" &&  return 0 || return 1 
}

# 创建用户跟ssh入口函数
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

# 创建用户入口函数
createuser_main(){
    if [ "$?" == 0 ]; then
            echo "Please replace the user that needs to be created !!!"
            exit 1
    else
            echo "Starting create username\n"
            createUserName
            echo "SUCCEEDFUL!!"
    fi
}

# 创建密钥入口函数
createssh_main(){
	existUserName $1
	if [ "$?" == 0 ]; then
		echo "ok The user is exist"
	else
		echo "The user is not exist"
		exit 1
	fi
	addKeyUsers $1
	if [ "$?" == 0 ]; then
		echo "ok The key is exist"
		exit 1
	else
		echo "the Key is not exist"
	fi
	createUserSsh
}

# 删除用户跟密钥 入口函数
deleteuserssh_main(){
	delUserSsh $1
	local USER=$1
	if [ "$?" == 0 ]; then
		echo "The user is exist"
		echo "Starting remove user"
		[ -d "/home/${USER}" ] && rm -rf /home/${USER} && userdel ${USER}|| userdel ${USER}
		echo "remove ${USER} SUCCEEDFUL"
	else
		echo "The user is not exist Unable to delete"
		exit 1
	fi
}

# 调用函数
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
		deleteuserssh_main $1
                ;;
        -G|--creategroup)
                shift
                ;;
	-g|--delgroup)
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

