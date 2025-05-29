#!/bin/bash

exec > >(tee /var/log/base_install/launch_config_user_data_log/user-data-install-cloudwatch-agent.log|logger -t user-data -s 2>/dev/console) 2>&1

Region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -c -r .region)
sudo echo `date '+%Y-%m-%d %H:%M:%S '` "Installing CloudWatch Agent"
sudo wget https://s3.$Region.amazonaws.com/amazoncloudwatch-agent-$Region/redhat/arm64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
sudo cp /home/ec2-user/linux-app-stack/config_cw.json /opt/aws/amazon-cloudwatch-agent/bin/config.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
echo `date '+%Y-%m-%d %H:%M:%S '` "CloudWatch agent Running"


