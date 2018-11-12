#!/bin/bash
# author for yangzhaoyu 2018.11.10
# use CentOS 7.x for CentOS 6.x


Apache_menu(){
	cat << EOF
----------------------------------------
|************apaceh menu************|
----------------------------------------	
`echo -e "\033[35m 1)Apache installation\033[0m"`
`echo -e "\033[35m 4)exit\033[0m"`
EOF

read -p "Do you install Apache?" apache
if [ "$apache" -eq "1" ]; then 
	change_menu
elif [ "$apache" -eq "2" ]; then 
	echo "Sign out"
	exit 1
fi
cat 
}

change_menu(){
	cat << END
----------------------------------------
|************Choice menu************|
----------------------------------------
`echo -e "\033[35m 1)Apache2.4.37 installation\033[0m"`
`echo -e "\033[35m 4)exit\033[0m"`	
END
read -p ""
}
Apache_menu

