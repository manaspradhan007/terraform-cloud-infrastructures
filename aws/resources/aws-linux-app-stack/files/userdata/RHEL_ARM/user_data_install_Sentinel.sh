#!/bin/bash

exec > >(tee /var/log/base_install/launch_config_user_data_log/user-data-install-sentinel.log|logger -t user-data -s 2>/dev/console) 2>&1

curl -s -k https://<url-here>/SentinelOneInstallerLinux | sudo bash
