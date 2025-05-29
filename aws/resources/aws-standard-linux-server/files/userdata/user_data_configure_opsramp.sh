#!/bin/bash
##. ./user_data_function_library.sh
exec > >(tee /var/log/base_install/user-data-ops-ramp.log|logger -t user-data -s 2>/dev/console) 2>&1

ClientCode=${client_code}

#Change to root user and path setting
sudo su
echo `date '+%Y-%m-%d %H:%M:%S '` "Changed to root user"

#Install opsramp agent
echo `date '+%Y-%m-%d %H:%M:%S '` "Download opsramp agent"
EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"

aws configure set default.region $EC2_REGION

aws s3 cp s3://opsramp-agents-prod/$ClientCode-opsramp-linux-agent.py /tmp/opsramp-linux-agent.py

#Install opsramp agent
echo `date '+%Y-%m-%d %H:%M:%S '` "Install opsramp agent"
python /tmp/opsramp-linux-agent.py -i silent

#Enable opsramp-agent 
echo `date '+%Y-%m-%d %H:%M:%S '` "Enable opsramp-agent"
systemctl enable opsramp-agent
#service opsramp-agent enable

#Enable opsramp-shield
echo `date '+%Y-%m-%d %H:%M:%S '` "Enable opsramp-shield"
systemctl enable opsramp-shield
#service opsramp-shield enable

#Restart opsramp-agent
echo `date '+%Y-%m-%d %H:%M:%S '` "Restart opsramp-agent"
systemctl restart opsramp-agent
#service opsramp-agent restart

#Restart opsramp-shield
echo `date '+%Y-%m-%d %H:%M:%S '` "Restart opsramp-shield"
systemctl restart opsramp-shield
#service opsramp-shield restart

#Check opsramp-agent status
echo `date '+%Y-%m-%d %H:%M:%S '` "Check opsramp-agent status"
systemctl status opsramp-agent
#Check opsramp-shield status
echo `date '+%Y-%m-%d %H:%M:%S '` "Check opsramp-shield status"
systemctl status opsramp-shield