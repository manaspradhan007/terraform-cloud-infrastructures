#!/bin/bash

if [ ! -d /var/log/base_install/launch_config_user_data_log ]; then
  sudo mkdir -m 777 -p /var/log/base_install/launch_config_user_data_log
fi
if [ ! -d /scripts ]; then
  sudo mkdir -m 777 /scripts
fi
exec > >(tee /var/log/base_install/launch_config_user_data_log/user-data-aws-cli.log|logger -t user-data -s 2>/dev/console) 2>&1

TenantCode=${tenant_code}
Region=${region}
TenantEnvironment=${tenant_environment}
InstallRapid7=${install_rapid7}
installcw=${installcw}

echo `date '+%Y-%m-%d %H:%M:%S '` "Restart vasd"
sudo /opt/quest/bin/vastool daemon restart vasd
sleep 30s

#Register with Satellite Server
echo `date '+%Y-%m-%d %H:%M:%S '` "Register with Satellite Server"
curl -s -k https://<url-here>/RH7 | sudo bash

#Install Python
echo `date '+%Y-%m-%d %H:%M:%S '` "Install Python"
sudo yum -y install python3

#Install PIP
echo `date '+%Y-%m-%d %H:%M:%S '` "Install PIP"
curl -O https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py

export PATH=/usr/local/bin:$PATH

pip install urllib3 --upgrade

#Install AWS CLI
echo `date '+%Y-%m-%d %H:%M:%S '` "Install AWS CLI"
pip install awscli --upgrade

#switch to root user after pip install
echo `date '+%Y-%m-%d %H:%M:%S '` "Switch to root user after pip in"
sudo su
cd

#Setting up path for all users
printf "PATH=/usr/local/bin:\$PATH\nexport PATH" > /etc/profile.d/pip_env.sh
chmod +x /etc/profile.d/pip_env.sh

source /etc/profile.d/pip_env.sh

#Install Ruby
echo `date '+%Y-%m-%d %H:%M:%S '` "Install Ruby"
yum install -y ruby

#Install jq
wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 
chmod +x ./jq
cp jq /usr/bin

#Copy from MS to TenantBucket
aws s3 cp s3://${bucket}/${resource_name_prefix}/linux-app-stack /home/ec2-user/linux-app-stack --recursive
#Set Hostname
cd /home/ec2-user/linux-app-stack/ && chmod 777 user_data_configure_hostname.sh
./user_data_configure_hostname.sh $TenantCode $Region $TenantEnvironment

echo `date '+%Y-%m-%d %H:%M:%S '` "Set Hostname complete"
cd

#Install CloudWatch Agent
if [ $installcw = true ];
then
  echo `date '+%Y-%m-%d %H:%M:%S '` "Installing CloudWatch Agent"
  cd /home/ec2-user/linux-app-stack/ && chmod 777 user_data_install_cloudwatch-agent.sh
  ./user_data_install_cloudwatch-agent.sh
else
  echo `date '+%Y-%m-%d %H:%M:%S '` "CloudWatch Agent Installation Disabled"
fi

#Update Timezone to UTC
echo "Update Timezone to UTC"
timedatectl set-timezone UTC

#Install Rapid7 Agent
if [ $InstallRapid7 = true ];
then
  echo `date '+%Y-%m-%d %H:%M:%S '` "Installing Rapid7 Agent"
  curl -s -k <url here> | bash
else
	echo `date '+%Y-%m-%d %H:%M:%S '` "Rapid7 Agent Installation Disabled"
fi

#Install Code Deploy Agent
echo `date '+%Y-%m-%d %H:%M:%S '` "Install Code Deploy Agent"
aws s3 cp s3://aws-codedeploy-$Region/latest/install . --region $Region
chmod +x ./install
./install auto

#Install SSM
echo `date '+%Y-%m-%d %H:%M:%S '` "SSM Agent install"
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sleep 30

#Update users.allow file
echo `date '+%Y-%m-%d %H:%M:%S '` "Add  OPS to the users.allow"
echo "AWSCLOUD\IND-OPS" >> /etc/opt/quest/vas/users.allow
echo "AWSCLOUD\USA-OPS" >> /etc/opt/quest/vas/users.allow

#Adding  OPS users to Sudoers
echo "%IND-OPS ALL=(root) NOPASSWD: ALL" >> /etc/sudoers
echo "%USA-OPS ALL=(root) NOPASSWD: ALL" >> /etc/sudoers

chmod 777 InvokeScripts.sh
./InvokeScripts.sh $TenantCode ${client_code} $Region $TenantEnvironment ${bucket} ${tenant_trend_api_url} ${tenant_trend_api_username} ${tenant_trend_api_password} ${tenant_trend_api_auth_secret} ${tenant_trend_cloud_account_name} ${install_sentinelone} ${kafka_elb_endpoint} ${tenant_kafka_beat_topic} ${tenant_kafka_configuration_version} ${tenant_kafka_metricbeat_topic} ${tenant_kafka_metricbeat_configuration_version} ${tenant_environment_sequence} ${tenant_vas_username} ${tenant_vas_password} ${master_tenant_environment} ${resource_stack_vas_ou} ${sumo_logic_secret_id} ${resource_name_prefix} ${tenant_s3_artifact_customscript}