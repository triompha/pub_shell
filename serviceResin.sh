#!/bin/bash
#developed by zhiyongzhao(triompha)
#date 2013-09-24
#version 1.0.0

if [ -z $1 ]||[ -z $2 ];then
	echo -e "\e[0;31;1mUsage: $0 remote_ip commond \e[0m"
        exit 1;
fi
ip=$1
command=$2
echo -e "\e[0;34;1mExecute:"sh /usr/local/resin/bin/httpd.sh $command"\e[0m"
ssh -l root $ip "source /etc/profile && sh /usr/local/resin/bin/httpd.sh $command > /dev/null&"

