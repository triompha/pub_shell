#!/bin/bash
#developed by zhiyongzhao(triompha)
#date 2013-09-24
#aim version back automatic
#version 1.0.0

plist="/home/triompha/.ssh/iplist"
if [ -z $1 ]||[ -z $2 ];then
        echo "Wrong Usage............"
        echo "Usage: $0 ip:app_dir version"
        exit 1;
fi
ip=`echo $1|awk -F : '{print $1}'`
remote_dir=`echo $1|awk -F : '{print $2}'`
app_name=`echo $remote_dir|awk '{ sub(/.*\//, ""); print }'`
remote_dir=${remote_dir:0:${#remote_dir}-${#app_name}}
version=$2

pub_date=bak.`date +%Y%m%d%H%M`
echo -e "\e[0;34;1mVersion back $1 to $2 \e[0m"
ssh -l root $ip "cd $remote_dir && mv $app_name $app_name.$pub_date && cp -r $app_name.$version $app_name"
