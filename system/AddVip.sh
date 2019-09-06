#!/bin/bash
# author: yangzhaoyu time:2019-09-09
# used add Vip

VIP=()
i=1
for v in ${VIP[@]}; do
        if [ -f /etc/sysconfig/network-scripts/ifcfg-lo:${i} ]; then
                echo "file exist"
        else
                touch /etc/sysconfig/network-scripts/ifcfg-lo:${i}
                cat >> /etc/sysconfig/network-scripts/ifcfg-lo:${i} <<-EOF
                DEVICE=lo:${i}
                IPADDR=$v
                NETMASK=255.255.255.255
                EOF
                ifup lo:${i}
        fi
        let i++
        [ $i -eq 11 ] && break
