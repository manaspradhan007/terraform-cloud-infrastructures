#!/bin/bash
exec > >(tee /var/log/base_install/launch_config_user_data_log/user-data-install-snowagent.log|logger -t user-data -s 2>/dev/console) 2>&1
#This script installs Snowagent
#Installing Snowagent

yum install -y java-1.8.0-openjdk

SNOWDIR="/opt/snow"
SNOWAGENT=$(rpm -qa snowagent)

if [[ $? -eq 0 ]] && [[ -d "$SNOWDIR" ]] ; then
  SNOW="Installed"
  echo "Snow Agent already installed"
else
  echo 'Installing snowagent'
  /bin/yum -y remove snowagent
  sleep 2
  /bin/yum -y install snowagent
  SNOW="Installed"
  echo "Snow Agent Installed"
fi

#Checking snowagent.config file exists
if [ ! -e $SNOWDIR/snowagent.config ] ; then
   SNOWCFG=$(ls $SNOWDIR | grep CONFIG)
   cd $SNOWDIR
   ln -s $SNOWCFG snowagent.config
fi

SNOWCFG=/opt/snow/snowagent.config
#Validating snowagent ACTIVE status 
for i in `grep http $SNOWCFG | awk -F/ '{print $3}' | awk -F: '{print $1}'`
do
timeout 3 bash -c "</dev/tcp/$i/80" >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
   STATUS=$($SNOWDIR/snowagent test)
   if [[ $? -eq 0 ]] ; then
    echo "Active" > $SNOWDIR/status
    echo "Snow Agent is Active"
    RC=0
    exit $RC
   else
    echo "Failed_test" > $SNOWDIR/status
    RC=1
    exit $RC
   fi
else
  echo "Port 80 not open to gateways" > $SNOWDIR/status
  RC=1
fi
done
