# Microservice Name
terraform-aws-linux-app-resource-stack
   
# Purpose
This microservice allows user to create a linux app resource stack with specific software pre-installed.


v6.1.0

# Sprint detail
This version is being released as part of  Sprint <>.

## Provider Details
| Name                  | Description           | Version |
| --------------------- |:---------------------:|  --------:|
| AWS | AWS provider version |  v2.70.0       |
| Terraform | Terraform version  |  v0.12.31       |

# Changes included
This version of microservice includes this change.
- Installation of Trend-Micro script with the retry/timeout flags for TFO

## Technical Notes
Updated existing trend micro script has been  with the retry/timeout flags

##  Changes in Inputs
No changes included in existing input

##  Changes in Outputs 
No changes included in existing ouputs





v6.0.0


# Changes included
This version of microservice includes this change.
- Removed hardcoded username and password.

##### Technical Notes
 Development team has removed all the hardcoded username and passwords from the microservice. Please use terraform-aws-ops-params microservice to call the username and passwords from the secret manager.

##  Changes in Inputs  
| Name                  | Description           | Type  | Default | Required |
| --------------------- |:---------------------:| -----:| -------:| --------:|
| tenant_trend_api_username | Tenant trend api url api username | string| "" | Yes       |
| tenant_trend_api_password | Tenant trend api password        | string| "" | Yes       |
| tenant_trend_api_auth_secret | Tenant trend api auth secret  | string| "" | Yes       |
| tenant_vas_username | Tenant VAS username         | string| "" | Yes       |  
| tenant_vas_password | Tenant VAS password         | string| "" | Yes       | 

##  Changes in Outputs 
No changes included in existing ouputs.


----------------------------------------------------------------------------------


v5.10.2


# Changes included
- Userdata upload location in S3 changed to include resource_name_prefix.

##### Technical Notes
Upload location of userdata changed from <artifacts_bucket>/linux-app-stack to <artifacts_bucket>/<resource_name_prefix>/linux-app-stack.
This is to ensure that uploaded userdata does not conflict with older versions of app stack in the same bucket.

##  Changes in Inputs  
No changes have been made in Inputs

##  Changes in Outputs 
No changes included in existing ouputs

----------------------------------------------------------------------------------



v5.10.1


# Changes included
This version of microservice includes this change.
- Upgaded the python version in aws_cli userdata script which will install the latest python version and the latest pip version as well.
- Added a new variable that updates the default Version of launch templte on each update.

##### Technical Notes
 Development team has upgraded the python version in aws_cli userdata script which installs the latest python version and latest pip version.

##  Changes in Inputs  
Following inputs have been added with this release:-

| Name                  | Description           | Type  | Default | Required |
| --------------------- |:---------------------:| -----:| -------:| --------:|
| update_default_launch_template_version | Updates the default Version of launch templte on each update         | bool| true | no       |


##  Changes in Outputs 
No changes included in existing ouputs



v5.10.0


# Changes included
This version of microservice includes this change.
- Upgaded the python version in aws_cli userdata script which will install the latest python version and default pip version as well.

##### Technical Notes
 Development team has upgraded the python version in aws_cli userdata script which installs the latest python version and default pip version.

##  Changes in Inputs  
No changes included in existing inputs

##  Changes in Outputs 
No changes included in existing ouputs




v5.9.0


# Changes included
This version of microservice includes this change.
- Added ASG update script which will triggers when there is launch template change.

##### Technical Notes
 Development team has added recycle_asg script which will be triggerd when there is launch template change while provisioning.

##  Changes in Inputs  
No changes included in existing inputs

##  Changes in Outputs 
No changes included in existing ouputs



tfo-v5.8.0


# Changes included
This version of microservice includes this change.
- Changed source links pointing from TFE links to bitbucket links

##### Technical Notes
Source links have been changed from TFE links to bitbucket links for the purpose of TFE to TFO migration

##  Changes in Inputs  
No changes included in existing inputs

##  Changes in Outputs 
No changes included in existing ouputs



v5.8.0


# Changes included
This version of microservice includes this change.
- Added sumo_logic_agent installation using token.

##### Technical Notes
 Development team has modified sumo_logic_agent intallation via token instead of access key and secret.

##  Changes in Inputs  
No changes included in existing inputs

##  Changes in Outputs 
No changes included in existing ouputs




v5.7.2
 

# Changes included
This version of microservice includes this change.
- Added tenant_kafka_beat_topic variable
- Added tenant_kafka_configuration_version variable
- Added tenant_kafka_metricbeat_topic variable
- Added tenant_kafka_metricbeat_configuration_version variable
 
##### Technical Notes
 Development team has exposed the [tenant_kafka_beat_topic,tenant_kafka_configuration_version,tenant_kafka_metricbeat_topic,tenant_kafka_metricbeat_configuration_version] as a variable . This is to support filebeat and metricbeat topic and version. This change has no affect on AL functionality. 
The value is defaulted to the previously hardcoded value, "[oslogs,0.11.0.0,metricbeat,0.11.0.0]".


##  Changes in Inputs  
| Name                  | Description           | Type  | Default | Required |
| --------------------- |:---------------------:| -----:| -------:| --------:|
| tenant_kafka_beat_topic | kafka topic         | string| "oslogs" | no       |
| tenant_kafka_configuration_version | version        | string| "0.11.0.0" | no       |
| tenant_kafka_metricbeat_topic | metricbeat topic         | string| "metricbeat" | no       |
| tenant_kafka_metricbeat_configuration_version | metric beat yml version         | string| "0.11.0.0" | no       |

##  Changes in Outputs 
No changes included in existing outputs.



v5.7.1
 

# Changes included
This version of microservice includes this change.
- Added enable_codedeploy_check to avoid infinite loop issue when artifact is missing

 
##### Technical Notes
 Development team has exposed a new variable, "enable_codedeploy_check", to allow unite team to disable the codedeploy check functionality, which will cause the microservice to enter an infinite loop when it is run without a valid artifact file.
When set to true, the functionality will remain the same as before, where the check will run. When set to false, this task is skipped.


##  Changes in Inputs  
| Name                    | Description                           | Type    | Default | Required |
| ----------------------- |:-------------------------------------:| -------:| -------:| --------:|
| enable_codedeploy_check | Enable codedeploy check functionality | boolean | true    | no       |

##  Changes in Outputs 
No changes included in existing outputs.


 
------------------------------------------------------------------------   



v5.7.0


# Changes included
This version of microservice includes this change.
- Added resource_stack_vas_ou variable

 
##### Technical Notes
 Development team has exposed the vas ou as a variable named resource_stack_vas_ou. This is to support creation of Unite EC2 Maintenance stacks, which require a different value for this. This change has no affect on AL functionality. 
The value is defaulted to the previously hardcoded value, "api".


##  Changes in Inputs  
| Name                  | Description           | Type  | Default | Required |
| --------------------- |:---------------------:| -----:| -------:| --------:|
| resource_stack_vas_ou | VAS OU value          | string| "api"   | no       |

##  Changes in Outputs 
No changes included in existing outputs.


 
------------------------------------------------------------------------   


v5.6.0
 

# Changes included
This version of microservice includes this change.
- Updated microservice to accept any customscript name
- Added jq install for sumologic

 
##### Technical Notes
 Development team has removed the hardcoding of the customscript in userdata. (was formerly hardcoded to user-data-configure_appsetting.sh)


##  Changes in Inputs  
No changes included in existing outputs.

##  Changes in Outputs 
No changes included in existing outputs.


 
------------------------------------------------------------------------   


v5.5.0


# Changes included
This version of microservice includes this change.
- Added RHEL_ARM folder for M6g instance type

##### Technical Notes
MS changed to Support the AWS M6G Instance Type.Scripts are separated on the basis of os flavour in the micro-service.

##  Changes in Inputs  
| Name          | Description           | Type  | Default | Required |
| ------------- |:---------------------:| -----:| -------:| --------:|
| os_flavour    | os flavour type       | string| "RHEL"  | yes  |

##  Changes in Outputs 
No changes included in existing outputs.


 
------------------------------------------------------------------------   



v5.4.0
 


# Changes included
This version of microservice includes this change.
- Updated microservice to accept inputs to support the au liquibase microservice.
- Added new variables to expose previously hardcoded values in the microservice.
 
##### Technical Notes
 Development team has added the below variable in the tfvars file of this microservice
--asg_dereg_lambda_sg_ids
--rollback_option
 


##  Changes in Inputs  
| Variable Name | Default Value | Description |
|:--------------|:--------------------- |:-----------|
|asg_dereg_lambda_sg_ids|[]|Security group ID for the Dereg Lambda function. Will use previously created or specified security groups if empty|
|rollback_option|true|Disable or enable codedeploy rollback in case of failure|

##  Changes in Outputs 
No changes included in existing outputs.


------------------------------------------------------------------------   


v5.2.1


# Changes included
This version of microservice includes this change.
-  flag for Installation of Sentinel Agent.

#### Change 1 - Installing Sentinel Agent
Additionally, this microservice includes a functionality to install Sentinel agent or Trend agend in linux instance through userdata scripts.

##### Technical Notes
 Development team has added  additional variable in the tfvars file of this microservice


##  Changes in Inputs  

| Variable Name | Default Value | Description |
|:--------------|:--------------------- |:-----------|
|install_sentinelone| false | Setting this value will allow trend to exceute. If this variable is true then sentenial once will execute


##  Changes in Outputs 
No changes included in existing outputs.

CHANGELOG.md

------------------------------------------------------------------------   



v5.2.0


# Changes included
This version of microservice includes this change.
- Installation of Sentinel Agent.

#### Change 1 - Installing Sentinel Agent
Additionally, this microservice includes a functionality to install Sentinel agent in linux instance through userdata scripts.

##### Technical Notes
 Development team hasnt added any additional variable in the tfvars file of this microservice


##  Changes in Inputs  
No changes included in existing input.



------------------------------------------------------------------------   


V5.1.0

# Changes included
This version of microservice includes this change.
- Added inspec folder , inside the example.

 
##### Technical Notes
 Development team has added the below variable in the tfvars file of this microservice
Added a Inspec suite to example folder.
 
##  Changes in Inputs  
No changes included in existing outputs.

##  Changes in Outputs 
No changes included in existing outputs.


------------------------------------------------------------------------ 



v5.0.5
 

# Changes included
This version of microservice includes this change.
- Fixed ASG policy and alarms attachment issues.

##### Technical Notes
 Development team has modified internal logic to take care of attachment of alarms to ASG scaling policies .

##  Changes in Inputs  
No changes included in existing outputs.

##  Changes in Outputs 
No changes included in existing outputs.




v5.0.4
 

# Changes included
This version of microservice includes this change.
- Fixed blue-green-deployment.tf to avoid index error when manually delete asg.

##### Technical Notes
 Development team has modified var.execute_microservice ? aws_autoscaling_group.this[0].name : "" to avoid index error when manually deleting asg .

##  Changes in Inputs  
No changes included in existing outputs.

##  Changes in Outputs 
No changes included in existing outputs.




v5.0.3


# Changes included
This version of microservice includes this change.
- Added condition check var.execute_microservice in main.tf and blue-green-deployment.tf to avoid index error when setting execute_microservice flag to false.
- Updated alarm_actions     = ["${aws_autoscaling_policy.scale-up-policy-b[0].arn}"] with alarm_actions     = ["${aws_autoscaling_policy.scale-up-policy-b[count.index].arn}"] in cpu based alarm and Memory based alarm in blue-green-deployment.tf and inplace-deployment.tf to fix alarm not setting into multiple ASG policy.
 
##### Technical Notes
 Development team has introduced condition check for main.tf and blue-green-deployment.tf to avoid index error when setting flag execute_microservice variable to false.

 Development team has modified cpu based and memory based alarm to set alarm to multiple ASG policy. Alarm will be set to ASG policy in order ASG policy and alarm created.

##  Changes in Inputs  
No changes included in existing outputs.

##  Changes in Outputs 
No changes included in existing outputs.

# Link to Changelog
To learn more about all changes included, please visit [here](https://git.cnvrmedia.net/projects/LMD/repos/terraform-aws-linux-app-resource-stack/browse/CHANGELOG.md)

------------------------------------------------------------------------ 
