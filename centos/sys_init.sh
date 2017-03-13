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
net=$(ls|grep 'ifcfg-em1')
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

##更新yum安装常用软件
yum -y install wget
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all && yum makecache
yum -y update
yum -y install  unzip lrzsz  git net-tools ntpdate 
yum -y remove firewalld 
ntpdate us.pool.ntp.org
echo "30 * * * * root ntpdate us.pool.ntp.org">>/etc/crontab
echo -e "\033[32m 系统更新完毕，时间已同步. \033[0m"
sleep 3s

##系统参数调优
cat >>/etc/sysctl.d/99-sysctl.conf<<EOF
vm.swappiness = 0
net.ipv4.ip_forward = 1
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096        87380   4194304
net.ipv4.tcp_wmem = 4096        16384   4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 30
net.ipv4.ip_local_port_range = 1024    65000
EOF
cat >>/etc/security/limits.conf<<EOF
* soft nofile 1024000
* hard nofile 1024000
EOF

echo -e "\033[32m 请手动重启系统. \033[0m"
sleep 3
echo -e "\033[32m 重启后的IP地址： \033[0m" $IP
sleep 3s
exit 0