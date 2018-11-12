#!/bin/bash
#author for yangzhaoyu 2018.11.10
# use install LAMP and LNMP scrips

Selection_menu(){
	cat << EOF
----------------------------------------
|************Selection menu************|
----------------------------------------
`echo -e "\033[35m 1)LNMP installation\033[0m"`
`echo -e "\033[35m 2)LAMP installation\033[0m"`
`echo -e "\033[35m 3)uninstall\033[0m"`
`echo -e "\033[35m 4)exit\033[0m"` 
EOF

}

install_function(){
read -p "Please input the number you want to select(1-4):" num1
if [ ! -n "`echo $num1 | sed 's/[0-9]//g'`"  ]; then
	if [ $num1 -gt 0 ] && [ $num1 -le 4 ]	;then
		case $num1 in 
			1)
				echo -e "\033[35m 1)Start installing LNMP !!! please writing installation\033[0m"
				;;
			2)
				echo -e "\033[35m 1)Start installing LAMP !!! please writing installation\033[0m"
				;;
			3)
				echo -e "\033[35m 1)Uninstall all installed !!! please writing installation\033[0m"
				;;
			4)			
				echo -e "\033[35m 1)No installation and exit !!! exit installation\033[0m"
				exit 1
				;;
		esac
	else	
			echo -e "\033[35m 1)The number you entered is not integer and is between 1-4. exit installation\033[0m"
	fi
else
		echo -e "\033[35m 1)Input is string instead of integer exit.\033[0m"
fi
}
Selection_menu
install_function
