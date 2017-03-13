#!/bin/bash
echo -e "\033[32m 开始配置系统环境...... \033[0m"
sleep 3s
##网卡自动化配置
read -p "输入主机名:" HOSTNAME
read -p "输入静态IP地址：" IP
read -p "输入子网掩码:" MS
read -p "输入网关地址：" GT
hostnamectl set-hostname $HOSTNAME
cd /etc/sysconfig/network-scripts/
net=$(ls|grep 'ifcfg-eth0')
sed -i s/dhcp/static/g /etc/sysconfig/network-scripts/$net
sed -i s/ONBOOT=no/ONBOOT=yes/g /etc/sysconfig/network-scripts/$net
cat>>/etc/sysconfig/network-scripts/$net<<EOF
IPADDR=$IP
NETMASK=$MS
GATEWAY=$GT
DNS1=223.5.5.5
DNS2=223.6.6.6
EOF
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
setenforce 0
echo -e "\033[32m 网卡配置完毕. \033[0m"
sleep 3s
echo -e "\033[32m 重启后的地址$IP. \033[0m"
service network restart
rm -rf *.sh
