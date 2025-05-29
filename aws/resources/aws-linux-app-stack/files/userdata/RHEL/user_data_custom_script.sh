#!/bin/bash
exec > >(tee /var/log/base_install/launch_config_user_data_log/user-data-custom-script.log|logger -t user-data -s 2>/dev/console) 2>&1

tenant_s3_customscript=${1}

echo "Custom Script Location: "$tenant_s3_customscript

echo `date '+%Y-%m-%d %H:%M:%S '` "Uninstall urllib3"
pip uninstall urllib3 -y

echo `date '+%Y-%m-%d %H:%M:%S '` "Renstalling python urllib3"
sudo yum remove python-urllib3 -y
sudo yum install python-urllib3 -y

echo `date '+%Y-%m-%d %H:%M:%S '` "Installing python request"
sudo yum install python-requests -y

echo `date '+%Y-%m-%d %H:%M:%S '` "Installing AWS CLI"
pip install awscli

if [ -z $tenant_s3_customscript ];
then
echo `date '+%Y-%m-%d %H:%M:%S '` "No custom script to execute"
else
echo `date '+%Y-%m-%d %H:%M:%S '` "Copying Customscript"
aws s3 cp $tenant_s3_customscript /home/ec2-user/
flist=(`aws s3 ls $tenant_s3_customscript | awk '{print $4}'`)
echo $flist

result=$(sh /home/ec2-user/$flist >> /var/log/base_install/launch_config_user_data_log/$flist.log)
echo $result

fi
