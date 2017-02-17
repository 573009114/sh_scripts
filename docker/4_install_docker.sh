#!/bin/bash
read -p "输入你上传脚本的目录:" dir
curl -fsSL https://get.docker.com/ | sh
\cp $dir/docker /etc/sysconfig/docker
\cp $dir/docker-storage /etc/sysconfig/docker-storage
\cp $dir/docker.service /usr/lib/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker 
chkconfig docker on 
echo -e "\033[32m docker成功启动. \033[0m"