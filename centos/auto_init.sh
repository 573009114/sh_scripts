#!/bin/bash
echo -e "\033[32m 正在自动化配置系统环境...... \033[0m"
sleep 3s
##网卡自动化配置
read -p "输入主机名:" HOSTNAME
read -p "输入静态IP地址：" IP
read -p "输入子网掩码:" MS
read -p "输入网关地址：" GT
read -p "输入你上传脚本的目录:" dir
lsblk
read -p "请输入你的docker所使用的磁盘：(必须是绝对路径！)" disk
hostnamectl set-hostname $HOSTNAME
cd /etc/sysconfig/network-scripts/
net=$(ls|grep 'ifcfg-eno16')
sed -i s/dhcp/static/g /etc/sysconfig/network-scripts/$net
sed -i s/ONBOOT=no/ONBOOT=yes/g /etc/sysconfig/network-scripts/$net
cat>>/etc/sysconfig/network-scripts/$net<<EOF
IPADDR=$IP
NETMASK=$MS
GATEWAY=$GT
DNS1=114.114.114.114
EOF
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
setenforce 0
echo -e "\033[32m 网卡配置完毕. \033[0m"
sleep 3s

##更新yum安装常用软件
yum -y install wget
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all && yum makecache
yum -y update
yum -y install  unzip lrzsz net-tools ntpdate 
ntpdate us.pool.ntp.org
echo "30 * * * * root ntpdate us.pool.ntp.org">>/etc/crontab
echo -e "\033[32m 系统更新完毕，时间已同步. \033[0m"
sleep 3s

##设置docker_pool
pvcreate $disk
vgcreate docker $disk
lvcreate --wipesignatures y -n thinpool docker -l 95%VG 
lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG 
lvconvert -y --zero n -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta 
touch  /etc/lvm/profile/docker-thinpool.profile
cat >>/etc/lvm/profile/docker-thinpool.profile<<EOF
activation { 
    thin_pool_autoextend_threshold=80
    thin_pool_autoextend_percent=20
}
EOF
lvchange --metadataprofile docker-thinpool docker/thinpool
lvs -o+seg_monitor
echo -e "\033[32m 存储池设置完毕. \033[0m" 
sleep 3s

##安装docker服务
curl -fsSL https://get.docker.com/ | sh
\cp $dir/docker /etc/sysconfig/docker
\cp $dir/docker-storage /etc/sysconfig/docker-storage
\cp $dir/docker.service /usr/lib/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker 
chkconfig docker on 
echo -e "\033[32m docker成功启动. \033[0m"
sleep 3s

##系统参数调优
cat >>/etc/sysctl.d/99-sysctl.conf<<EOF
vm.swappiness = 0
net.ipv4.neigh.default.gc_stale_time=120
net.ipv4.ip_forward=1
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.all.arp_announce=2
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 1024
net.ipv4.tcp_synack_retries = 2
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv4.conf.lo.arp_announce=2
EOF
cat >>/etc/security/limits.conf<<EOF
* soft nofile 65535
* hard nofile 65535
EOF

echo -e "\033[32m 请手动重启系统. \033[0m"
sleep 3
echo -e "\033[32m 重启后的IP地址： \033[0m" $IP
sleep 3s
exit 0





