#!/bin/bash
echo -e "\033[32m 正在自动化配置系统环境...... \033[0m"
sleep 3s
##网卡自动化配置
read -p "输入主机名:" HOSTNAME
read -p "输入静态IP地址：" IP
read -p "输入子网掩码:" MS
read -p "输入网关地址：" GT
hostnamectl set-hostname $HOSTNAME
cd /etc/sysconfig/network-scripts/
net=ifcfg-eth0
sed -i s/dhcp/static/g /etc/sysconfig/network-scripts/$net
cat>>/etc/sysconfig/network-scripts/$net<<EOF
IPADDR=$IP
NETMASK=$MS
GATEWAY=$GT
DNS1=114.114.114.114
EOF
echo -e "\033[32m 网卡配置完毕,正在重启... \033[0m"
sleep 3s
service network restart