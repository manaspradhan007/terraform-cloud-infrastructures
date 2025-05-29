#!/bin/bash
#Checking codedeploy-agent is running or not

exec > >(tee /var/log/base_install/launch_config_user_data_log/start-codedeploy-agent.log|logger -t user-data -s 2>/dev/console) 2>&1
service=codedeploy-agent
if [[ -z $(ps -ef |grep $service) ]]
then 
   echo `date '+%Y-%m-%d %H:%M:%S '` "$servicestarting"
  /etc/init.d/$service start
else
   echo "$service is running!!!"
fi


  