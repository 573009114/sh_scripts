#!/bin/bash
#安装jdk
cp -rf ./* /home
cd /home 
rpm -ivh *.rpm 
cat>>/etc/profile<<EOF
export JAVA_HOME JAVA_HOME=/usr/java/jdk1.8.0_121
EOF
source /etc/profile
#tomcat
tar -xvf tomcat8.tar 
  