#!/bin/bash
#developed by zhiyongzhao(triompha)
#date 2013-09-24
#aim deploy web app automatic
#version 1.0.0

#some default static , change this to fix your system
svn_root="/home/triompha/svn/hot_vis/"
iplist="/home/triompha/.ssh/iplist"
deploy_dir="www"

REGEX_IP="^(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])(\.(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])){3}$"


shell_root=`dirname $0`
homedir=`pwd`
app_name=`echo $1|awk '{ sub(/.*\//, ""); print }'`

#must input app_name , and the app exist
if [ -z ${app_name} ]||[ ! -d ${svn_root}${app_name} ]||[ -z $2 ];then
         echo -e "\e[0;31;1mUsage: $0 app_name ip_alise \e[0m"
         exit 1;
fi

#if input deploy_dir ,set it
if [ ! -z $3 ];then
 deploy_dir=$3
fi

#allocate the remote_ip 
#if more than one , confirm if user want to continue
#if input ip direct , use it
if [[ $2 =~ $REGEX_IP ]];then
  ips=$2
else
  ips=`cat ${iplist}|grep "$2"|awk -F '=' {'print $2'}`
fi

count=`echo "$ips" |wc -l`

if [ $count -gt 1 ];then
   echo -e "\e[0;31;1mAttention: you choose more than 1 ip of \e[0m"
   echo -e "\e[0;31;1m$ips\e[0m"
   echo -e "\e[0;31;1mDo you really want to continue?\e[0m"
   select var in "Abort" "Continue";do
      break;
   done
   echo $var
   if [ $var -eq "Abort" ];then
      echo xfasdf
      exit 1
   fi
else if [ $count -lt 1 ] || [ -z $ips ]; then
        echo -e "\e[0;31;1mCan not locate 1 IP \e[0m"
        exit 1;
     fi
fi

#when you execute other shell,you must find the right shell location
#cd ${homedir} 
#the execute bash ${shell_root}/yourshell
#that`s why we save "dirname $0",and pwd
#so you can execute this shell any where


cd ${svn_root}${app_name}
echo -e "\e[0;34;1mUpdate svn to the latest version \e[0m"
svn --non-interactive update
echo -e "\e[0;34;1mMaven compile classes \e[0m"
mvn clean package -Dmaven.test.skip=true
cd target && tar -czf $app_name.tar.gz $app_name
if [ ! -f $app_name.tar.gz ] || [ ! -d $app_name ];then
   echo -e "\e[0;31;1mCan not find tar file , may coplile error \e[0m"
   exit 1
fi

cd ${homedir}
for ip in $ips; do
  bash ${shell_root}/syncTarToRemote.sh ${svn_root}${app_name}/target/${app_name}.tar.gz $ip $deploy_dir
  bash ${shell_root}/serviceResin.sh $ip stop
  bash ${shell_root}/releaseTar.sh ${svn_root}${app_name}/target/${app_name}.tar.gz $ip $deploy_dir
  bash ${shell_root}/serviceResin.sh $ip start
  if [ $count -gt 1 ];then
	sleep 10s
  fi
done
  bash ${shell_root}/showResinLog.sh $ip

