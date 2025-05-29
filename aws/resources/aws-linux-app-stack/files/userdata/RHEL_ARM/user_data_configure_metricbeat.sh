#!/bin/bash

exec > >(tee /var/log/base_install/launch_config_user_data_log/user-data-configure-metricbeat.log|logger -t user-data -s 2>/dev/console) 2>&1

TenantCode=$1
platform=$2
beattype=$3
kafkaElbEndpoint=$4
tenantKafkaBeatTopic=$5
tenantKafkaMetricbeatConfigurationVersion=$6

echo $TenantCode
echo $platform
echo $beattype
echo $kafkaElbEndpoint
echo $tenantKafkaBeatTopic
echo $tenantKafkaMetricbeatConfigurationVersion

echo `date '+%Y-%m-%d %H:%M:%S '` "Copying Metricbeat.yml"
sudo cp /home/ec2-user/linux-app-stack/metricbeat.yml.original /scripts/metricbeat.yml.original

#Install Metricbeat
echo `date '+%Y-%m-%d %H:%M:%S '` "Install Metricbeat"
sudo yum localinstall -y https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.8.1-x86_64.rpm 

#Configure Metricbeat
echo `date '+%Y-%m-%d %H:%M:%S '` "Configuring Metricbeat for beat topic"

sed -i -- 's/<TENANT_CODE>/'$TenantCode'/g' /scripts/metricbeat.yml.original
sed -i -- 's/<PLATFORM>/'$platform'/g' /scripts/metricbeat.yml.original
sed -i -- 's/<BEAT_TYPE>/'$beattype'/g' /scripts/metricbeat.yml.original
sed -i -- 's/<KAFKA_ELB>/'$kafkaElbEndpoint'/g' /scripts/metricbeat.yml.original
sed -i -- 's/<TENANT_KAFKA_BEAT_TOPIC>/'$tenantKafkaBeatTopic'/g' /scripts/metricbeat.yml.original
sed -i -- 's/<TENANT_KAFKA_METRICBEAT_CONFIGURATION_VERSION>/'$tenantKafkaMetricbeatConfigurationVersion'/g' /scripts/metricbeat.yml.original

sudo cp /scripts/metricbeat.yml.original /etc/metricbeat/metricbeat.yml

#Start Metricbeat
echo `date '+%Y-%m-%d %H:%M:%S '` "Start Metricbeat"
service metricbeat enable
service metricbeat start