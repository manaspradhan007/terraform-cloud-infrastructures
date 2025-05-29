#!/bin/bash
exec > >(tee /var/log/base_install/user-data-install-sumologic.log|logger -t user-data -s 2>/dev/console) 2>&1

ClientCode=${client_code}
SecretId=${sumo_logic_secret_id}
Environment=${tenant_environment}

CollectorName=$(hostname -f)

echo "CollectorName: "$CollectorName
echo "SecretId: " $SecretId

sudo cp /home/ec2-user/sources.json scripts/sources.json
wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 
chmod +x ./jq
cp jq /usr/bin

#Get SumoLogic Secrets
echo `date '+%Y-%m-%d %H:%M:%S '` "Executing Cli command to Secrets Manager"

SumoSecret=$(aws secretsmanager get-secret-value --secret-id $SecretId --region us-east-1 --version-stage AWSCURRENT --query SecretString)
echo "Getting token from Seceret manager....... " 

category=$ClientCode/aws/$Environment/compute/linux

sed -i "s|<category>|$category|g" scripts/sources.json

SumoToken=$(echo $SumoSecret | jq -r 'fromjson | .Token')
echo "Extracting token ....... " 

#Execute Install SumoLogic 
echo `date '+%Y-%m-%d %H:%M:%S '` "Execute SumoLogic Script"

echo "Download SumoLogic Installer"
yum -y install wget
sudo wget "https://collectors.sumologic.com/rest/download/linux/64" -O SumoCollector.sh && sudo chmod +x SumoCollector.sh

echo "Run SumoLogic Installer"
#echo ./SumoCollector.sh -q -Vephemeral=true -Vsources=/scripts/sources.json -Vcollector.name=$CollectorName -Vsumo.token_and_url=$SumoToken
sudo ./SumoCollector.sh -q -Vephemeral=true -Vsources=/scripts/sources.json -Vcollector.name=$CollectorName -Vsumo.token_and_url=$SumoToken