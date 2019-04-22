#!/bin/bash
# author yangzhaoyu for 20190422
# pyenv install 

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

EXIT_OK=0
EXIT_WARNING=1
EXIT_ERROR=2


# Determine if the user is root
rootNess(){
    if [[ ${EUID} -ne 0 ]]; then
       log "Error" "This script must be run as root"
       exit 1
    fi
}

# Install centos components

Gain_CentosForPyenv(){
	sudo yum install gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel 2&>/dev/null
	echo "SUCCEED !!"
	return ${EXIT_OK}
}

# Install pyenv
Gain_Pyenv(){
	[ ! -f "~/.pyenv" ] || exit ${EXIT_ERROT}
	if [ ! -f "/usr/bin/git" ]; then
		yum -y install git 2&>/dev/null
		git clone https://github.com/pyenv/pyenv.git ~/.pyenv 2&>/dev/null
		echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
		echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
		echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc
		exec $SHELL
	else
		git clone https://github.com/pyenv/pyenv.git ~/.pyenv 2&>/dev/null
		echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
                echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
                echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc
		exec $SHELL
	fi
	echo "SUCCEED!!"
	return ${EXIT_OK}
}

# Installation component 
Gain_Pyenv-Virtualenv(){
	[ ! -d "~/.pyenv/plugins/" ] || exit ${EXIT_ERROR}
	if [ ! -d "~/.pyenv/plugins/pyenv-virtualenv" ]; then
		git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
		echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
		exec $SHELL
	else
		exit ${EXIT_ERROR}
	fi
	echo "SUCCESS!!"
	return ${EXIT_OK}
}

echo '###################################### INSTALLATION PYENV ######################################'
read -p "Do you install the version directly(Y/N)" IN
while :;do
	case $IN in
	Y|y)
		read -p "Input you should installtion python version" PV
		pyenv install $VS 2&>/dev/null
		pyenv virtualenv $VS ${VS}-dev 2&>/dev/null
		read -p "Do you want active Py(Y/N):" PY
		while :; do
        		[ "$PY" == "y" ] || [ "$PY" == P"Y" ] && {
                		pyenv activate ${PV}-env
                		continue
        		}
        		[ "$PY" == "N" ] || [ "$PY" == "n" ] && {
                		break
        		}
        		read -p "I don\'t now you input !"
		done
		;;
	N|n)
		exit ${EXIT_WARNING}	
	esac
done
	
