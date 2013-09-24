#!/bin/bash
#developed by zhiyongzhao(triompha)
#date 2013-09-24
#version 1.0.0

if [ ! -e $1 ]||[ -z $2 ]||[ -z $3 ];then
        echo "Wrong Usage............"
        echo "Usage: $0 app.tar.gz remote_ip remote_dir"
        exit 1;
fi
tar_file=`echo $1|awk '{ sub(/.*\//, ""); print }'`
app_name=`echo ${tar_file}|awk -F . '{print $1}'`
ip=$2
remote_dir=$3
pub_date=`date +%Y%m%d%H`
echo -e "\e[0;34;1mRelease ${ip}:/opt/${remote_dir}/${app_name} $pub_date \e[0m"
ssh -l root $ip "cd /opt/${remote_dir} && cp -r $app_name $app_name.$pub_date"
ssh -l root $ip "cd /opt/${remote_dir} && rm -rf $app_name && tar -xzf ${tar_file} && chown -R resin:root $app_name"

