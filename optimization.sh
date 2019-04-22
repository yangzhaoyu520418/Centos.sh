#!/bin/bash
# author yangzhaoyu 2018.11.9
# use CentOS 6.x and CentOS 7.x 



PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

FILES=`find /etc -name ifcfg-e* -print`
network_dir=`find /etc -name ifcfg-e* -print | awk -F/ '{print $5}'`
Edition_number=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release) )
platform=`uname -i`
type=`cat /etc/redhat-release | awk '{print $1}'`
date_number=`date +%Y%m%d`
cpu_cores=`cat /proc/cpuinfo | grep "cpu cores" | uniq | awk -F: '{print $2}'`
Mentotal_number=`cat /proc/meminfo | grep MemTota|awk -F: '{print $2}'`
yum_source=`find /etc/ -name yum.repos.*`
yum_dir=/etc/yum.repos.d/CentOS-Base.repo
epel_dir=/etc/yum.repos.d/epel.repo
yum_url=http://mirrors.aliyun.com/repo/Centos-$Edition_number.repo
epel_url=http://mirrors.aliyun.com/repo/epel-$Edition_number.repo
backup_dir=/opt
type_platform(){
#
if [ "$type" == "CentOS" ]; then
	echo "You type is CentOS OK!!"
else
	echo "You type is not CentOS"
	exit 1 
fi
#
if [ "$platform" == "x86_64" ]; then
	echo "You platform is x86_64 OK!!"
else
	echo "You platform is not x86_64 exit"
	exit 1
fi
}

network_work(){
network_file=`cat /etc/sysconfig/network-scripts/$network_dir | grep ONBOOT= | awk -F= '{print $2}'`
if [ "$Edition_number" == "7" ]; then
	if [ "$network_file" == "no" ]; then
		sed -i 's/ONBOOT=no/ONBOOT=yes/' $FILES
		systemctl restart network 2&> /dev/null
		echo "over"
	elif [ "$netwok_file" == "yes" ]; then
		echo "warring Then ONBOOT=yes not change"
	fi
elif [ "$Edition_number" == "6" ]; then
	if [ "$network_file" == "yes"  ]; then 
		sed -i 's/ONBOOT=//' $FILES
	elif [ "$network_file" == "\"yes\"" ]; then
		sed -i 's/ONBOOT="on"/ONBOOT=\"yes\"/' $FILES
		/etc/init.d/network restart 2&> /dev/null
	elif [ ! -z  "$network_file" ]; then
		echo "ONBOOT=yes" >> $FILES
	else 
		exit
	fi 
else 
	echo "You type don\'t know"
	exit 1
fi

}

yum_modify(){
if [ "$Edition_number" == "7" ]; then
	mv $yum_source/CentOS-Base.repo $backup_dir/CentOS-Base.repo.bak 2&>/dev/null
	yum install -y wget 2&>/dev/null
	wget -O $yum_dir $yum_url 2&>/dev/null
	wget -O $epel_dir $epel_url 2&>/dev/null
	echo "Success"
elif [ "$Edition_number" == "6" ]; then
	mv $yum_source/CentOS-Base.repo $backup_dir/CentOS-Base.repo.bak 2&>/dev/null
	yum install -y wget 2&>/dev/null
	wget -O $yum_dir $yum_url 2&>/dev/null
	wget -O $epel_dir $epel_url 2&>/dev/null
	echo "Success"
else 
	echo "error exit script error!!"
fi
yum makecache 2&>/dev/null				
}

install_Software(){
read -p "you want tp install soft please input: or eixt please input null:" soft
yum -y install  python-pip python-devel make openssl-devel >/dev/null 2>&1
yum -y install gcc-c++ gcc unzip vim-enhanced unrar sysstat net-tools >/dev/null 2>&1
while [ ! -z "$soft"  ]; do
        yum -y install $sofe 2&> /dev/null
        Succes=`echo $?`
        if [ $Succes -ne 0 ]; then
            echo "file  bad parameter is $Succes"
        else
            echo "Succes"
        fi
        read -p "you want to install soft please again input or eixt please input null:" soft
done
echo "stop install"
}

date_sync(){ 
if [ "${Edition_number}" == "7" ]; then
	yum -y install ntp 2&>/dev/null
	rm -rf /etc/localtime 
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	touch /etc/sysconfig/clock
	echo "ZONE="Asia/Shanghai"" >> /etc/sysconfig/clock
	echo "UTC=false" >> /etc/sysconfig/clock
	echo "ARC=false" >> /etc/sysconfig/clock
	systemctl start ntpd 2&>/dev/null
	systemctl enable ntpd 2&>/dev/null
	echo "/usr/sbin/ntpdate ntp1.aliyun.com > /dev/null 2>&1; /sbin/hwclock -w" >> /etc/rc.d/rc.local
	echo "0 */1 * * * ntp1.aliyun.com >/dev/null 2>&1; /sbin/hwclock -w" >> /var/spool/cron/root
elif [ "${Edition_number}" == "6" ]; then
	yum -y install ntp 2&> /dev/null
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	touch /etc/sysconfig/clock
	echo "ZONE="Asia/Shanghai"" >> /etc/sysconfig/clock
	echo "UTC=false" >> /etc/sysconfig/clock
	echo "ARC=false" >> /etc/sysconfig/clock
	service ntpd start 2&>/dev/null
	chkconfig ntpd on 2&> /dev/null
	echo "/usr/sbin/ntpdate ntp1.aliyun.com > /dev/null 2>&1; /sbin.hwclock -w" >> /etc/rc.d/rc.local
	echo "0 */1 * * * ntp1.aliyun.com >/dev/null 2>&1; /sbin/hwclock -w" >> /var/spool/cron/root
else
	echo "error"	
fi

}
	
dns_modify(){
if [ "${Edition_number}" == "7" ]; then
#	sed -i '/nameserver/d' /etc/resolv.conf
	echo "DNS1=8.8.8.8" >> $FILES
	echo "DNS2=8.8.4.4" >> $FILES
	systemctl restart network 2&>/dev/null
elif [ "${Edition_number}" == "6" ]; then
#	sed -i '/nameserver/d' /etc/resolv.conf
	echo "DNS1=8.8.8.8" >> $FILES
	echo "DNS2=8.8.4.4" >> $FILES
	/etc/init.d/network restart 2>&1 /dev/null	
else
	echo "I don\'t know type"
	exit 0
fi
}

kernel_modify(){
	read -p "please input Maximum number of open file descriptions:(102400)" max_number
	if [ ! -z "${max_number}"  ] || [ "${max_number}" -gt "0" ]; then
		echo "ulmit -SHn ${max_number}" >> /etc/rc.local
	else 
		echo "error you input ${max_number} is not int"
		echo "Qing is manually generated after script completion."
	fi
	
cat >> /etc/security/limits.conf << EOF
*		soft 	nofile		655350
* 		hard 	nofile		655350
EOF

local sysctl=`cat /etc/sysctl.conf | wc -l`
if [ "${sysctl}" -le "10" ]; then
cat >> /etc/sysctl.conf << EOF
# 禁用ipv6服务
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
# 取消掉swap不使用交换内存
vm.swappiness=0
# 决定检查过期多久的邻居条目
net.ipv4.neigh.default.gc_stale_time=120
# 关闭反向路径查询
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
#防止arp广播
net.ipv4.conf.lo.arp_announce=2
net.ipv4.conf.all.arp_announce=2
net.ipv4.conf.default.arp_announce=2
# time-work等待时间数量最大为5000
net.ipv4.tcp_max_tw_buckets=5000
# 增强抵御syn flood攻击
net.ipv4.tcp_syncookies=1
# syn列队的长度为1024
net.ipv4.tcp_max_syn_backlog=1024
# 减少syn重新连接的次数
net.ipv4.tcp_synack_retries=2
#启用 sysrq功能
kernel.sysrq=1
EOF
sysctl -p >>/dev/null
else 
	echo "Already written"
fi		
}

firewalld_selinux(){
if [ "${Edition_number}" == "7"  ];then
	systemctl stop firewalld >/dev/null 2>&1 &
	systemctl disable firewalld >/dev/null 2>&1 &
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
	setenforce 0
elif [ "${Edition_number}" == "6" ];then
	service iptables stop 2>/dev/null 2>&1 &
	chkconfig iptables off 2>/dev/null 2>&1 &
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
	setenforce 0 	
else 
	echo "exit"
	exit 0
fi

}



echo "####################################Welcome to use scripting optimisation systems####################################"
echo "start opyimizing loading......."
echo "Wait for the 30 Temple and start....."
echo "If you have error please  Ctrl+C End this script."
echo "Warnning!!! Some parameters have been written dead."
echo "#############To configure##############"
echo "DATA 	 :        ${date_number}"
echo "CPU	 :        ${cpu_cores}"
echo "MEN	 :${Mentotal_number}"
echo "#######################################"
type_platform
echo "starting..... and writing....."
sleep 30
network_work
dns_modify
yum_modify
date_sync
kernel_modify
firewalld_selinux
install_Software
echo "###################################Do you want to restart the computer?###################################"
read -p "y/Y or n/N:" change
case ${change} in 
y|Y)
	echo "please writing 10s reboot computer!!!"
	sleep 10
	reboot
	;;
N|n)
	echo "exit script over"
	echo "warning!! Need to restart to ensure the stability of the system."
	;;
esac
