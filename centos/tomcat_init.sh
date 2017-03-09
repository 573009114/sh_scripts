#!/bin/bash
#安装jdk
cp -rf ./* /home
cd /home 
rpm -ivh *.rpm 
cat>>/etc/profile<<EOF
JAVA_HOME=/usr/java/jdk1.8.0_121
JRE_HOME=$JAVA_HOME/jre
PATH=$PATH:$JAVA_HOME/bin
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_HOME
export JRE_HOME
export PATH
export CLASSPATH
EOF
source /etc/profile
#tomcat
tar -xvf tomcat8.tar 
