#!/usr/bin/env bash
# author: yangzhaoyu time: 2019-08-30
# used: lvs installtion

# To determine the user
rootNess(){
        [ ${UID} -eq 0 ] && return 0 || return 1 && echo "You user is not root" && exit 1
}

# Yum installtion
yum_Ist(){
        yum -y install gcc gc gcc-c++ kernel-devel libnl* libpopt* popt-static > /dev/null
        [ $? -eq 0 ] && return 0 || return 1 && echo "You please installtion soft" && exit 1
}

#  Service adjustment
service_ad(){
        systemctl stop firewalld 2>&1 > /dev/null
        systemctl disable firewalld 2>&1 /dev/null
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config 2>&1 /dev/null
        cat >> /etc/sysctl.conf <<-EOF
        net.ipv4.ip_forward = 1
	EOF
        sysctl -p > /dev/null
}

# Install the LVS
install_Lvs(){
        local LVS_URL="https://mirrors.edge.kernel.org/pub/linux/utils/kernel/ipvsadm/ipvsadm-1.30.tar.xz"
        local WGET_DIR="/usr/bin/wget"
        local LVS_DIR="/soft/lvs"
        local IPVSADM_DIR
        local IPVS_STATUS_NUMBER=`lsmod | grep ip_vs | wc -l`
        [ -f "${WGET_DIR}" ] || yum -y install wget >> /dev/null
        [ -d "${LVS_DIR}" ] || mkdir -p ${LVS_DIR}
        wget -P ${LVS_DIR} ${LVS_URL}
        tar Jxf ${LVS_DIR}/${LVS_URL##*/} -C ${LVS_DIR}
        ln -s /usr/src/kernels/`uname -r` /usr/src/linux
        IPVSADM_DIR=`echo ${LVS_URL##*/} | awk -F'.' '{print $1"."$2}'`
        cd ${LVS_DIR}/${IPVSADM_DIR}/ ; make && make install
        modprobe ip_vs && modprobe ip_vs_wrr
	echo "options ip_vs conn_tab_bits=20" > /etc/modeprobd.d/lvs.conf
        [ ${IPVS_STATUS_NUMBER} -eq 0 ] && echo "The ipvs is not installtion" && exit 1 || {
            echo "The ipvs in installtion!!"
        }
}

rootNess
yum_Ist
service_ad
install_Lvs
