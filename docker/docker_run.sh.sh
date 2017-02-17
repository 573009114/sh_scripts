#!/bin/bash
#docker运行脚本
echo "请按照下边的参数认真填写，回车则参数为空"
read -p "输入要运行的服务名(--name abc):" NAME
read -p "输入要使用的镜像名:" IMAGE
read -p "输入容器映射端口关联:（例如:-p 80:80 或者 -p 80:80 -p 90:90 ）" PORT 
read -p "输入容器挂载目录关联:(例如:-v dvol:svol 或者 -v dvol1:svol1 -v dvol2:svol2 ..)" VOL
read -p "输入要使用的环境变量:(例如:-e foo=bar)" KV
read -p "是否需要自动启动:（y|n）" YN
read -p "输入容器最大内存限制:(例如 -m 1024m)" MEM
read -p "输入容器运行指令:" CMD
#判断是否需要自动启动
if  [ "$YN" = "y" ];then 
    RS=--restart=always
else
    echo "未设置自动重启"
    fi
echo "请确认以下运行参数:"
echo "docker run -tid ${NAME} ${PORT} ${VOL} ${RS} ${KV} ${MEM} --oom-kill-disable=true ${IMAGE}  ${CMD}" 
read -p "是否创建容器:(y|n)" RQ
if  [ "$RQ" = "y" ];then
    echo "正在创建中..."
    docker run -tid $NAME  $PORT $VOL $RS $KV $MEM $IMAGE $CMD
else
    echo "创建已取消！！"
    fi
    


