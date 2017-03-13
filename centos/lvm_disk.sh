#!/bin/bash
#lvm
lsblk
read -p "请输入你的使用的磁盘：(必须是绝对路径！)" disk
read -p "请输入新的挂载目的目录" mount
read -p "请输入分区名" name
read -p "请输入容量" size
mkdir /$mount 
pvcreate $disk
vgcreate $name $disk
lvcreate -n $name -L  $size $name
mkfs.xfs /dev/$name/$name 
mount /dev/$name/$name /$mount
echo "/dev/$name/$name /$mount xfs defaults 0 0">> /etc/fstab
