#!/bin/bash
#developed by zhiyongzhao(triompha)
#date 2013-09-24
#version 1.0.0

if [ ! -e $1 ]||[ -z $2 ]||[ -z $3 ];then
        echo "Wrong Usage............"
        echo "Usage: $0 app.tar.gz remote_ip remote_dir"
        exit 1;
fi

cd `dirname $1`
tar_dir=`pwd`
tar_file=`echo $1|awk '{ sub(/.*\//, ""); print }'`
app_name=`echo ${tar_file}|awk -F . '{print $1}'`
ip=$2
remote_dir=$3

echo -n "sync "
echo -ne "\e[0;34;1m ${tar_dir}${tar_file} \e[0m"
echo -n "to"
echo -e "\e[0;34;1m ${ip}:/opt/${remote_dir} \e[0m"
#make sure the dir exist
ssh -l root $ip "mkdir -p /opt/$remote_dir"
#scp file
scp  $tar_file root@$ip:/opt/$remote_dir/

