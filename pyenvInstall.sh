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
	yum -y install gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel >/dev/null 2&>1
	echo "SUCCEED !!"
	return ${EXIT_OK}
}

# Install pyenv
Gain_Pyenv(){
	[ -d "~/.pyenv" ] && exit ${EXIT_OK}
	if [ ! -f "/usr/bin/git" ]; then
		yum -y install git >/dev/null
		git clone https://github.com/pyenv/pyenv.git ~/.pyenv
		echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
		echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
		echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc
		source ~/.bashrc
		
	else
		git clone https://github.com/pyenv/pyenv.git ~/.pyenv 
		echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
                echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
                echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc
		source ~/.bashrc
	fi
	echo "SUCCEED!!"
	return ${EXIT_OK}
}

# Installation component 
Gain_Pyenv_Virtualenv(){
	[ ! -d "~/.pyenv/plugins/" ] || exit ${EXIT_OK}
	if [ ! -d "~/.pyenv/plugins/pyenv-virtualenv" ]; then
		git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
		echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
		source ~/.bashrc
	else
		exit ${EXIT_ERROR}
	fi
	echo "SUCCESS!!"
	return ${EXIT_OK}
}


# Install Python 
Intsall_Python_Version(){
	pyenv install 2.7.15 >> /dev/null
	pyenv install 3.6.8 >> /dev/null
	pyenv virtualenv 2.7.15 2.7.15-env
	pyenv virtualenv 3.6.8 3.6.8-env
}

echo '###################################### INSTALLATION PYENV ######################################'
rootNess
Gain_CentosForPyenv
Gain_Pyenv
Gain_Pyenv_Virtualenv
Intsall_Python_Version
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
        		read -p "I don\'t now you input ! pleas Input (Y/N)"
		done
		;;
	N|n)
		exit ${EXIT_WARNING}
		;;	
	esac
done
	
