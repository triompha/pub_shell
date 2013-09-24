#!/bin/bash

resin_dir=/usr/local/resin

if [ -z $1 ];then
	echo -e "\e[0;31;1mUsage: $0 remote_ip resin_dir \e[0m"
        exit 1;
fi
ip=$1
if [ ! -z $2 ];then
	resin_dir=$2
fi
if [[ $resin_dir =~ .*/$ ]];then
	resin_dir=${resin_dir:0:${#resin_dir}-1}
	echo $resin_dir
fi
echo -e "\e[0;34;1mShow ${ip}:${resin_dir}/log/stdout.log\e[0m"
ssh -l root $ip "tail -f $resin_dir/log/stdout.log"

