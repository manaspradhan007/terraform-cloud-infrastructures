#!/bin/bash
#*****************
#
# Trend agent install
#
# This script detects platform and architecture, then downloads and installs the matching Deep Security Agent package
#  Pass it two variables. They are listed below
#  First one is the TenantID
#  Second one is the TenantPassword
#
#*****************

tenantID=$1
tenantPassword=$2
#RHEL=`cat /etc/redhat-release | awk '{print $7}' | awk -F. '{print $1}'`

#*****************
#
# Checking variables
#
#****************
var()
{
   if [ -z $tenantID ] ; then
   echo " "
   echo `date '+%Y-%m-%d %H:%M:%S '` "Missing TenantID.   Please add TenantID and tenantPassword to the command lin
e."
   echo `date '+%Y-%m-%d %H:%M:%S '` "Example: ./trend.sh 123456789 123456789"
   echo " "
   exit 1
   fi

   if [ -z $tenantPassword ] ; then
   echo " "
   echo `date '+%Y-%m-%d %H:%M:%S '` "Missing tenantPassword.   Please add TenantID and tenantPassword to the command lin
e."
   echo `date '+%Y-%m-%d %H:%M:%S '` "Example: ./trend.sh 123456789 123456789"
   echo " "
   exit 1
   fi
}

var

echo `date '+%Y-%m-%d %H:%M:%S '` "Getting Trend Agent"
echo `date '+%Y-%m-%d %H:%M:%S '` " "
yum -y install wget
#wget https://<url-here>:443/software/agent/RedHat_EL$RHEL/x86_64/ -O /tmp/agent.rpm --no-check-certificate --quiet
#rpm -ihv /tmp/agent.rpm
#sleep 15
if [[ $(/usr/bin/id -u) -ne 0 ]]; then echo You are not running as the root user.  Please try again with root privileges.;
    logger -t You are not running as the root user.  Please try again with root privileges.;
    exit 1;
fi;
  if type curl >/dev/null 2>&1; then
    SOURCEURL='https://<url-here>:443'
    curl $SOURCEURL/software/deploymentscript/platform/linux/ -o /tmp/DownloadInstallAgentPackage --insecure --silent --tlsv1.2

    if [ -s /tmp/DownloadInstallAgentPackage ]; then
      . /tmp/DownloadInstallAgentPackage
      Download_Install_Agent
  else
     echo "Failed to download the agent installation script."
     logger -t Failed to download the Deep Security Agent installation script
     false
  fi
else 
  echo Please install CURL before running this script
  logger -t Please install CURL before running this script
  false
fi
sleep 15
/opt/ds_agent/dsa_control -r
echo `date '+%Y-%m-%d %H:%M:%S '` "Activating Trend Agent"
/opt/ds_agent/dsa_control -a dsm://<url-here>:4120/ "tenantID:$tenantID" "tenantPassword:$tenantPassword" --max-dsm-retries 2 --dsm-retry-interval 120
if [[ $? != 0 ]];then
 echo "Activating Trend Agent failed"
fi
echo `date '+%Y-%m-%d %H:%M:%S '` "Checking Agent Status"

status=$(/opt/ds_agent/dsa_query -c "GetAgentStatus" | grep "AgentStatus.agentState:")
activestatus="AgentStatus.agentState: green"
        if [[ "$status" == "$activestatus" ]];then
                echo `date '+%Y-%m-%d %H:%M:%S '` "Install Complete"
				echo " "
				/opt/ds_agent/dsa_query -c "GetAgentStatus" | grep "AgentStatus.agentState:"
				/opt/ds_agent/dsa_query -c "GetAgentStatus" | grep "AgentStatus.dsmUrl:"
        else
                echo  `date '+%Y-%m-%d %H:%M:%S '` "ERROR Agent status is not green"
        fi
echo " "
exit 0