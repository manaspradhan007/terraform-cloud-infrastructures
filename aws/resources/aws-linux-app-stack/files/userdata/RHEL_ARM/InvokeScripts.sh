#!/bin/bash

tenant_code=${1}
client_code=${2}
region=${3}
tenant_environment=${4}
bucket=${5}
tenant_trend_api_url=${6}
tenant_trend_api_username=${7}
tenant_trend_api_password=${8}
tenant_trend_api_auth_secret=${9}
tenant_trend_cloud_account_name=${10}
install_sentinelone=${11}
kafka_elb_endpoint=${12}
tenant_kafka_beat_topic=${13}
tenant_kafka_configuration_version=${14}
tenant_kafka_metricbeat_topic=${15}
tenant_kafka_metricbeat_configuration_version=${16}
tenant_environment_sequence=${17}
tenant_vas_username=${18}
tenant_vas_password=${19}
master_tenant_environment=${20}
resource_stack_vas_ou=${21}
sumo_logic_secret_id=${22}
resource_name_prefix=${23}
tenant_s3_artifact_customscript=${24}

exec > >(tee /var/log/base_install/launch_config_user_data_log/InvokeScripts.log|logger -t user-data -s 2>/dev/console) 2>&1

echo $tenant_code
echo $client_code
echo $region
echo $tenant_environment
echo $bucket
echo $tenant_trend_api_url
echo $tenant_trend_api_username
echo $tenant_trend_api_password
echo $tenant_trend_api_auth_secret
echo $tenant_trend_cloud_account_name
echo $install_sentinelone
echo $kafka_elb_endpoint
echo $tenant_kafka_beat_topic
echo $tenant_kafka_configuration_version
echo $tenant_kafka_metricbeat_topic
echo $tenant_kafka_metricbeat_configuration_version
echo $tenant_environment_sequence
echo $tenant_vas_username
echo $tenant_vas_password
echo $master_tenant_environment
echo $resource_stack_vas_ou
echo $sumo_logic_secret_id
echo $tenant_s3_artifact_customscript

#other variables
lower_tenant_code=${tenant_code,,}
lower_client_code=${client_code,,}
lower_tenant_environment=${tenant_environment,,}
lower_tenant_kafka_beat_topic=${tenant_kafka_beat_topic,,}
lower_tenant_kafka_metricbeat_topic=${tenant_kafka_metricbeat_topic,,}
platform="linux"
filebeat_beat_type="filebeat"
metricbeat_beat_type="metricbeat"
fileabeat_tenant_kafka_beat_topic="${lower_tenant_kafka_beat_topic}-${lower_tenant_code}"
metricbeat_tenant_kafka_beat_topic="${lower_tenant_kafka_metricbeat_topic}-${lower_tenant_code}"
filebeat_version=${tenant_kafka_configuration_version,,}
metricbeat_version=${tenant_kafka_metricbeat_configuration_version,,}

cd /home/ec2-user/linux-app-stack/
chmod 777 user_data_configure_trend_micro.sh
chmod 777 user_data_install_Sentinel.sh
chmod 777 user_data_configure_filebeat.sh
chmod 777 user_data_configure_metricbeat.sh
chmod 777 user_data_configure_vas.sh
chmod 777 user_data_configure_opsramp.sh
chmod 777 user_data_install_sumologic.sh
chmod 777 user_data_install_snowagent.sh
chmod 777 user_data_start-codedeploy-agent.sh
chmod 777 user_data_custom_script.sh

#Execute all userdata scripts
if [[ $install_sentinelone == "true" ]]; then
   ./user_data_install_Sentinel.sh
else
   ./user_data_configure_trend_micro.sh $tenant_trend_api_url $tenant_trend_api_username $tenant_trend_api_password $tenant_trend_api_auth_secret $tenant_trend_cloud_account_name
fi

./user_data_configure_filebeat.sh $lower_tenant_code $platform $filebeat_beat_type $kafka_elb_endpoint $fileabeat_tenant_kafka_beat_topic $filebeat_version

./user_data_configure_metricbeat.sh $lower_tenant_code $platform $metricbeat_beat_type $kafka_elb_endpoint $metricbeat_tenant_kafka_beat_topic $metricbeat_version

./user_data_configure_vas.sh $client_code $tenant_environment $tenant_environment_sequence $tenant_vas_username $tenant_vas_password $master_tenant_environment $resource_stack_vas_ou

./user_data_configure_opsramp.sh $client_code

./user_data_install_sumologic.sh $lower_client_code $sumo_logic_secret_id $lower_tenant_environment $bucket $resource_name_prefix

./user_data_install_snowagent.sh 

./user_data_start-codedeploy-agent.sh

./user_data_custom_script.sh $tenant_s3_artifact_customscript