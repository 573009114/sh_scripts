#!/bin/bash
#docker pool set
read -p "请输入你的docker所使用的磁盘：(必须是绝对路径！)" disk
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
rm -rf docker_pool.sh 