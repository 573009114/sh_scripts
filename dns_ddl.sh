#!/bin/bash
#查看当前的DNS解析
cat -n  /etc/dnsmasq.hosts 
#判断用户操作
read -p "请输入指令决定要执行的操作（add|del）:" DDL
if  [ "$DDL" = "add" ];then
    echo "您选择的是添加一个解析"
    read -p "输入您的新解析（ex：123.123.123.123 test.xx):" ADD
    echo  "$ADD">>/etc/dnsmasq.hosts
    cat /etc/dnsmasq.hosts |grep "$ADD"
elif [ "$DDL" = "del" ];then
    echo "您选择的是删除一个解析"
    read -p "请输入要删除的解析行" DEL
    sed -i  " $DEL d" /etc/dnsmasq.hosts
    sed -i '/^$/d' /etc/dnsmasq.hosts
else
exit 0
fi
systemctl restart dnsmasq
echo "操作成功"
