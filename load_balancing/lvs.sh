#!/usr/bin/env bash
# author: yangzhaoyu time: 2019-08-30
# used: lvs installtion

# To determine the user
rootNess(){
	echo "Detecting root users !!"
        [ ${UID} -eq 0 ] && echo "OK!!" && return 0  || return 1 && echo "You user is not root" && exit 1
}

# Yum installtion
yum_Ist(){
	echo "Start install system environmental science"
        yum -y install gcc gc gcc-c++ libnl* libpopt* popt-static popt-devel > /dev/null
	[ $? -eq 0 ] && echo "OK!!" && return 0 || return 1 && echo "You please installtion soft" && exit 1
}

#  Service adjustment
service_ad(){
	echo "Turn off unnecessary services !!"
        systemctl stop firewalld 2>&1 > /dev/null
        systemctl disable firewalld 2>&1 /dev/null
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config 2>&1 /dev/null
        cat >> /etc/sysctl.conf <<-EOF
        net.ipv4.ip_forward = 1
	EOF
        sysctl -p > /dev/null
	echo "OK!!"
}

# Install the LVS
install_Lvs(){
	echo "Start installation Lvs"
        local IPVSADM_DIR
        local LVS_URL="https://mirrors.edge.kernel.org/pub/linux/utils/kernel/ipvsadm/ipvsadm-1.30.tar.xz"
        local WGET_DIR="/usr/bin/wget"
        local LVS_DIR="/soft/lvs"
        local IPVS_STATUS_NUMBER=`lsmod | grep ip_vs | wc -l`
        [ -f "${WGET_DIR}" ] || yum -y install wget >> /dev/null
        [ -d "${LVS_DIR}" ] || mkdir -p ${LVS_DIR}
        wget -P ${LVS_DIR} ${LVS_URL} >> /dev/null
        tar Jxf ${LVS_DIR}/${LVS_URL##*/} -C ${LVS_DIR}
        ln -s /usr/src/kernels/`uname -r` /usr/src/linux
        IPVSADM_DIR=`echo ${LVS_URL##*/} | awk -F'.' '{print $1"."$2}'`
        cd ${LVS_DIR}/${IPVSADM_DIR}/ ; make >> /dev/null  && make install >> /dev/null
        modprobe -r ip_vs_wrr && modprobe -r ip_vs_rr && modprobe -r ip_vs
	echo "options ip_vs conn_tab_bits=20" > /etc/modprobe.d/lvs.conf
	modprobe ip_vs && modprobe ip_vs_wrr && modprobe ip_vs_rr
        [ ${IPVS_STATUS_NUMBER} -eq 0 ] && echo "The ipvs is not installtion" && exit 1 || {
            echo "The ipvs in installtion!!"
        }
}

rootNess
yum_Ist
service_ad
install_Lvs
