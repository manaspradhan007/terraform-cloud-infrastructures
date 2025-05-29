#!/bin/bash
AWSCLI=/usr/local/bin/aws

if [ ! -d /var/log/base_install ]; then
  sudo mkdir -m 777 /var/log/base_install
fi

if [ ! -d /scripts ]; then
  sudo mkdir -m 777 /scripts
fi


exec > >(tee /var/log/base_install/user-data-aws-cli.log|logger -t user-data -s 2>/dev/console) 2>&1

TenantCode=${tenant_code}
Region=${region}
TenantHostName=${host_name}
InstallRapid7=${install_rapid7}


echo `date '+%Y-%m-%d %H:%M:%S '` "Restart vasd"
sudo /opt/quest/bin/vastool daemon restart vasd
sleep 30s

echo `date '+%Y-%m-%d %H:%M:%S '` "check connectivity to sts satellite link route"
for i in {1..30} ; do
  echo attempt $i
  traceroute -T -p 443 <url-here> && break
  traceroute -T -p 443 10.253.32.236
  [[ $i -eq 30 ]] && echo "tried $i times" && break
  sleep 10
done

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
echo `date '+%Y-%m-%d %H:%M:%S '` "Installing Ruby"
yum install -y ruby

#Set Hostname
echo `date '+%Y-%m-%d %H:%M:%S '` "Set Hostname"
sudo /usr/bin/hostnamectl set-hostname $TenantHostName

#Set Hostname Tag on Instance
EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`"
EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"

aws configure set default.region $EC2_REGION
echo "Instance ID  " $EC2_INSTANCE_ID
echo "HostName" $TenantHostName
echo "Region" $EC2_REGION
aws ec2 create-tags --resources $EC2_INSTANCE_ID --tags Key=HostName,Value=$TenantHostName

#Update Timezone to UTC
echo "Update Timezone to UTC"
timedatectl set-timezone UTC


#Install Rapid7 Agent
if [ $InstallRapid7 = true ];
then
    echo `date '+%Y-%m-%d %H:%M:%S '` "Installing Rapid7 Agent"
    curl -s -k http://pa2ustsxrhc06.aws.cloud.<company-name>/pulp/isos/<company-name>_STS/Library/custom/NormanProduct/NormanRepository/insight_installation_wrapper.sh | bash
else
	echo `date '+%Y-%m-%d %H:%M:%S '` "Installing Rapid7 Agent Installation Not Enabled"
fi


#Install AWS CLI
echo `date '+%Y-%m-%d %H:%M:%S '` "Installing AWS CLI"
if [ -f "$AWSCLI" ];
then
	echo "AWS CLI Already Installed"
else
	/bin/pip install awscli --upgrade
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
