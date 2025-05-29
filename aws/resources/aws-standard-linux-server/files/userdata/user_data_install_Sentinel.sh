#!/bin/bash

exec > >(tee /var/log/base_install/user-data-install_sentinel.log|logger -t user-data -s 2>/dev/console) 2>&1

curl -s -k https://<url-here>/SentinelOneInstallerLinux | sudo bash
