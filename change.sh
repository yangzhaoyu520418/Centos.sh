#!/bin/bash
# author for yangzhaoyu 2018.11.10
# use install LAMP and LNMP scrips




PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

date_number=`date +%Y%m%d`
cpu_cores=`cat /proc/cpuinfo | grep "cpu cores" | uniq | awk -F: '{print $2}'`
Mentotal_number=`cat /proc/meminfo | grep MemTota|awk -F: '{print $2}'`
echo "#############To configure##############"
echo "DATA 	 :        $date_number"
echo "CPU	 :        $cpu_cores"
echo "MEN	 :$Mentotal_number"
echo "#######################################"

Selection_menu(){
	cat << EOF
----------------------------------------
|************Selection menu************|
----------------------------------------
`echo -e "\033[35m 1)LNMP installation\033[0m"`
`echo -e "\033[35m 2)LAMP installation\033[0m"`
`echo -e "\033[35m 3)uninstall\033[0m"`
`echo -e "\033[35m 4)update\033[0m"`
`echo -e "\033[35m 5)exit\033[0m"` 
EOF

}

install_function(){

	local LAMP="./LAMP.sh"
	local LNMP="./LNMP.sh"
	local uninstall="./uninstall.sh"
	local update="./update.sh"
	read -p "Please input the number you want to select(1-5):" num1
while true ;do
	if [ ! -n "`echo $num1 | sed 's/[0-9]//g'`"  ]; then
		if [ $num1 -gt 0 ] && [ $num1 -le 5 ]; then
			case $num1 in 
				1)
					echo -e "\033[35m 1)Start installing LNMP !!! please writing installation\033[0m"
					if [ -s "$LNMP" ]; then
						source $LNMP
						break
					fi 
					;;
				2)
					echo -e "\033[35m 1)Start installing LAMP !!! please writing installation\033[0m"
					if [ -s "$LAMP" ]; then
						source $LAMP
						break
					fi
					;;
				3)
					echo -e "\033[35m 1)Uninstall all installed !!! please writing installation\033[0m"
					if [ -s "$uninstall" ]; then
						source $uninstall
						break
					fi
					;;
				4)
					echo -e "\033[35m 1)update all installed !!! please writing installation\033[0m"
					if [ -s "$update" ]; then
						source $update
						break
					fi
					;;
				5)			
					echo -e "\033[35m 1)No installation and exit !!! exit installation\033[0m"
					continue
					;;
					
			esac
		else	
				echo -e "\033[35m 1)The number you entered is not integer and is between 1-4. exit installation\033[0m"
		fi
	else
			echo -e "\033[35m 1)Input is string instead of integer exit.\033[0m"
	fi
	read -p "Please input the number you want to select again (1-5):" num1
done
}

Selection_menu
install_function
