#!/bin/bash

exec > >(tee /var/log/base_install/user-data-configure-filebeat.log|logger -t user-data -s 2>/dev/console) 2>&1

TenantCode=${tenant_code}
platform=${platform}
beattype=${beat_type}
kafkaElbEndpoint='${kafka_elb_endpoint}'
tenantKafkaTopic=${tenant_kafka_beat_topic}

echo $TenantCode
echo $platform
echo $beattype
echo $kafkaElbEndpoint
echo $tenantKafkaTopic


echo `date '+%Y-%m-%d %H:%M:%S '` "Copying Filebeat.yml"
sudo cp /home/ec2-user/filebeat.yml.original scripts/filebeat.yml.original

#Install Filebeat
echo `date '+%Y-%m-%d %H:%M:%S '` "Install Filebeat"
sudo yum localinstall -y https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.8.1-x86_64.rpm

#Configure Filebeat
echo `date '+%Y-%m-%d %H:%M:%S '` "Configuring Filebeat specify to tenant"

sed -i -- 's/<TENANT_CODE>/'$TenantCode'/g' ./scripts/filebeat.yml.original
sed -i -- 's/<PLATFORM>/'$platform'/g' ./scripts/filebeat.yml.original
sed -i -- 's/<BEAT_TYPE>/'$beattype'/g' ./scripts/filebeat.yml.original
sed -i -- 's/<KAFKA_ELB>/'$kafkaElbEndpoint'/g' ./scripts/filebeat.yml.original
sed -i -- 's/<TENANT_KAFKA_BEAT_TOPIC>/'$tenantKafkaTopic'/g' ./scripts/filebeat.yml.original

sudo cp ./scripts/filebeat.yml.original /etc/filebeat/filebeat.yml

#Start Filebeat
echo `date '+%Y-%m-%d %H:%M:%S '` "Start Filebeat"
service filebeat enable
sleep 15
service filebeat start
sleep 15
service filebeat start
sleep 15
service filebeat start
sleep 15
service filebeat start
echo "auto start filebeat"
systemctl enable filebeat