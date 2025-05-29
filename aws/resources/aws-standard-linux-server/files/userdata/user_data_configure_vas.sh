#!/bin/bash
exec > >(tee /var/log/base_install/user-data-configure-vas.log|logger -t user-data -s 2>/dev/console) 2>&1

TenantClientCode=${client_code}
TenantEnvironment=${tenant_environment}
TenantEnvironmentSequence=${tenant_environment_sequence}
TenantVASLinuxUsername=${tenant_vas_username}
TenantVASLinuxPassword=${tenant_vas_password}
MasterTenantEnvironment=${master_tenant_environment}


echo "TenantClientCode: "$TenantClientCode
echo "TenantEnvironment: "$TenantEnvironment
echo "TenantEnvironmentSequence: "$TenantEnvironmentSequence
echo "TenantVASLinuxUsername: "$TenantVASLinuxUsername
echo "TenantVASLinuxPassword: "$TenantVASLinuxPassword
echo "MasterTenantEnvironment: "$MasterTenantEnvironment

if [ $MasterTenantEnvironment != "PROD" ];then
    testflag=clients-testdev
else
    testflag=clients
fi

#Join Domain
echo `date '+%Y-%m-%d %H:%M:%S '` "Join Database Instance to Client Active Directory Domain"
sudo /opt/quest/bin/vastool -u $TenantVASLinuxUsername -w $TenantVASLinuxPassword join -f -c OU=db,OU=unix,OU=computers,OU=$TenantEnvironment$TenantEnvironmentSequence,OU=$TenantClientCode,OU=$testflag,OU=<company-name>-,DC=aws,DC=cloud,DC=<company-name> aws.cloud.<company-name>

#Quest Authentication Service
echo `date '+%Y-%m-%d %H:%M:%S '` "Quest Authentication Service"
sudo /opt/quest/bin/vgptool apply