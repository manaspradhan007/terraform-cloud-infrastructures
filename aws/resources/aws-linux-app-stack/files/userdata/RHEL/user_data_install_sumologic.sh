#!/bin/bash
exec > >(tee /var/log/base_install/launch_config_user_data_log/user-data-install-sumologic.log|logger -t user-data -s 2>/dev/console) 2>&1

ClientCode=${1}
SecretId=${2}
Environment=${3}
Bucket=${4}
ResourceNamePrefix=${5}

CollectorName=$(hostname -f)

echo "CollectorName: "$CollectorName
echo "SecretId: " $SecretId

aws s3 cp s3://$Bucket/$ResourceNamePrefix/linux-app-stack/sources.json /scripts/sources.json

#Get SumoLogic Secrets
echo `date '+%Y-%m-%d %H:%M:%S '` "Executing Cli command to Secrets Manager"
SecretString=$(aws secretsmanager get-secret-value --secret-id $SecretId --region us-east-1 --version-stage AWSCURRENT --query SecretString)

echo "Getting token from Seceret manager....... " 

category=$ClientCode/aws/$Environment/compute/linux

sed -i "s|<category>|$category|g" /scripts/sources.json

#Parse SecretString

SumoToken=$(echo $SecretString | jq -r 'fromjson | .Token')
echo "Extracting token ....... " 


#Execute Install SumoLogic 
echo `date '+%Y-%m-%d %H:%M:%S '` "Execute SumoLogic Script"
echo "Download SumoLogic Installer"
yum -y install wget
sudo wget "https://collectors.sumologic.com/rest/download/linux/64" -O SumoCollector.sh && sudo chmod +x SumoCollector.sh

echo "Run SumoLogic Installer"
#echo ./SumoCollector.sh -q -Vephemeral=true -Vsources=/scripts/sources.json -Vcollector.name=$CollectorName -Vsumo.token_and_url=$SumoToken
sudo ./SumoCollector.sh -q -Vephemeral=true -Vsources=/scripts/sources.json -Vcollector.name=$CollectorName -Vsumo.token_and_url=$SumoToken