#!/bin/bash
exec > >(tee /var/log/base_install/launch_config_user_data_log/user-data-configure-vas.log|logger -t user-data -s 2>/dev/console) 2>&1

TenantClientCode=${1}
TenantEnvironment=${2}
TenantEnvironmentSequence=${3}
TenantVASLinuxUsername=${4}
TenantVASLinuxPassword=${5}
MasterTenantEnvironment=${6}
ResourceStackVASOU=${7}

if [ $MasterTenantEnvironment != "PROD" ];then
    testflag=clients-testdev
else
    testflag=clients
fi

#Join Domain
echo `date '+%Y-%m-%d %H:%M:%S '` "Join API Instance to Client Active Directory Domain"
sudo /opt/quest/bin/vastool -u $TenantVASLinuxUsername -w $TenantVASLinuxPassword join -f -c OU=$ResourceStackVASOU,OU=unix,OU=computers,OU=$TenantEnvironment$TenantEnvironmentSequence,OU=$TenantClientCode,OU=$testflag,OU=<company-name>-,DC=aws,DC=cloud,DC=<company-name> aws.cloud.<company-name>


#Quest Authentication Service
echo `date '+%Y-%m-%d %H:%M:%S '` "Quest Authentication Service"
sudo /opt/quest/bin/vgptool apply

