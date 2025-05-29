#!/bin/bash
exec > >(tee /var/log/base_install/launch_config_user_data_log/user-data-install-trendmicro.log|logger -t user-data -s 2>/dev/console) 2>&1

#Get SSM Parameters
echo `date '+%Y-%m-%d %H:%M:%S '` "Get SSM Parameters"
TrendApiUrl=${1}
TrendApiUsername=${2}
TrendApiPassword=${3}
TrendApiAuthSecret=${4}
TrendTenantName=${5}

sudo cp /home/ec2-user/linux-app-stack/configure_trend_agent.sh /scripts/configure_trend_agent.sh

#Get Trend Session
echo `date '+%Y-%m-%d %H:%M:%S '` "Executing Trend Session API call"
TrendSid=$(\
curl -X POST https://$TrendApiUrl/rest/authentication/login/primary \
     -H "Content-Type:application/json" \
     -H "Basic "$TrendApiAuthSecret"" \
     -d '{"dsCredentials": {"userName": "'$TrendApiUsername'", "password": "'$TrendApiPassword'"}}' \
)
echo `date '+%Y-%m-%d %H:%M:%S '` "TrendSid: $TrendSid"

#Get Trend Tenant Data
echo `date '+%Y-%m-%d %H:%M:%S '` "Executing Trend Info API call"
TrendTenantDoc=$(\
curl https://$TrendApiUrl/rest/tenants/name/$TrendTenantName?sID=$TrendSid \
     -H "Accept-Language:en-US" \
)
#echo TrendIds: $TrendTenantDoc

#Parse Trend Tenant Data
TrendTenantId=$(grep -oPm1 "(?<=<guid>)[^<]+" <<< "$TrendTenantDoc")
TrendTenantPassword=$(grep -oPm1 "(?<=<agentInitiatedActivationPassword>)[^<]+" <<< "$TrendTenantDoc")

#Execute Configure Trend Agent Script
echo `date '+%Y-%m-%d %H:%M:%S '` "Execute Trend Agent Script"
sudo sh /scripts/configure_trend_agent.sh $TrendTenantId $TrendTenantPassword chdir=/installdb

#Logging out Trend Session
echo `date '+%Y-%m-%d %H:%M:%S '` "Logging out Trend Session"
TrendDeleteSid=$(\
curl -X DELETE https://$TrendApiUrl/rest/authentication/logout?sID=$TrendSid \
)
echo `date '+%Y-%m-%d %H:%M:%S '` "Logged out Trend Session"