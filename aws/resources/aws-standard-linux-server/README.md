# Microservice Name
terraform-aws-standard-linux-server
   
# Purpose
This microservice allows user to create an standalone linux server with <company-name> specific software pre-installed.




v3.1.0

# Sprint detail
This version is being released as part of  Sprint <>.
Jira Story [SKY-9653]:https://jira.cnvrmedia.net/browse/SKY-9653

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

# Link to Changelog
To learn more about all changes included, please visit [here]: https://git.cnvrmedia.net/projects/LMD/repos/terraform-aws-standard-linux-server/browse/CHANGELOG.md




v3.0.0

# Sprint detail
This version is being released as part of  Sprint <>.
Jira Story [SKY-9321]: https://jira.cnvrmedia.net/browse/SKY-9321

## Provider Details
| Name                  | Description           | Version |
| --------------------- |:---------------------:|  --------:|
| AWS | AWS provider version |  v2.70.0       |
| Terraform | Terraform version  |  v0.12.31       |

# Changes included
This version of microservice includes this change.
- Removed hardcoded username and password.
- Upgaded the python version and pip version in aws_cli userdata script.
- Removed Ansible.pem key. 

## Technical Notes
 Development team has removed all the hardcoded username and passwords from the microservice. Please use terraform-aws-ops-params microservice to call the username and passwords from the secret manager and terraform-azurerm-ssh-key-local-file to use the pem key.
 Development team has also upgraded the python version in aws_cli userdata script which installs the latest python version and latest pip version.  

##  Changes in Inputs
| Name                  | Description           | Type  | Default | Required |
| --------------------- |:---------------------:| -----:| -------:| --------:|
| tenant_trend_api_username | Tenant trend api url api username | string| "" | Yes       |
| tenant_trend_api_password | Tenant trend api password        | string| "" | Yes       |
| tenant_trend_api_auth_secret | Tenant trend api auth secret  | string| "" | Yes       |
| tenant_vas_username | Tenant VAS username         | string| "" | Yes       |  
| tenant_vas_password | Tenant VAS password         | string| "" | Yes       | 

##  Changes in Outputs 
No changes included in existing ouputs

# Link to Changelog
To learn more about all changes included, please visit [here]: https://git.cnvrmedia.net/projects/LMD/repos/terraform-aws-standard-linux-server/browse/CHANGELOG.md

-------------------------------------------------------------------------------



v2.11.0

# Sprint detail
This version is being released as part of  Sprint <>.
Jira Story [SKY-8605]: https://<company-name>jira.atlassian.net/browse/SKY-8605

# Changes included
This version of microservice includes this change.
- Added sumo_logic_agent installation using token.

##### Technical Notes
 Development team has modified sumo_logic_agent intallation via token instead of access key and secret.
  

##  Changes in Inputs  
No changes included in existing inputs


##  Changes in Outputs 
No changes included in existing ouputs

# Link to Changelog
To learn more about all changes included, please visit [here]: https://git.cnvrmedia.net/projects/LMD/repos/terraform-aws-standard-linux-server/browse/CHANGELOG.md




v2.10.0

# Sprint detail
This version is being released as part of  Sprint <>.
Jira Story [SKY-8355]: https://<company-name>jira.atlassian.net/browse/SKY-8355

# Changes included
This version of microservice includes this change.
- Added ebs_volume and volume attachment resource to attach other ebs volumes for Precog project along with device_name as a list and not a mandatory parameter.

##### Technical Notes
-  Development team has added additional variable in the tfvars file of this microservice
  | Variable Name | Default Value | Description |
  |:--------------:|:---------------------:|:-----------:|
  |default_linux_server_example_ebs_volumes| [] | List of ebs volumes to be attached to the instance. |


##  Changes in Inputs  
| Variable Name | Default Value | Description |
|:--------------:|:---------------------:|:-----------:|
|ebs_volumes| [] | List of ebs volumes to be attached to the instance.|


##  Changes in Outputs 
# Outputs provided
| Name                                  | Description           |
| ------------------------------------- |:---------------------:|
| attached_ebs_volumes                    | The list of map of all the attached ebs volumes along with different volume properties like  volume_size,volume_type,device_name,delete_on_termination,encrypted,iops,kms_key_id,volume_id|
| attached_root_volume                  | The list of map of the root volume along with different volume properties like  volume_size,volume_type,device_name,delete_on_termination,encrypted,iops,kms_key_id,volume_id |

# Link to Changelog
To learn more about all changes included, please visit [here]: https://git.cnvrmedia.net/projects/LMD/repos/terraform-aws-standard-linux-server/browse/CHANGELOG.md




v2.8.1

# Sprint detail
This version is being released as part of  Sprint <>.
Jira story [SKY-8412]: https://<company-name>jira.atlassian.net/browse/SKY-8412

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

# Link to Changelog
To learn more about all changes included, please visit [here]: https://git.cnvrmedia.net/projects/LMD/repos/terraform-aws-linux-app-resource-stack/browse/CHANGELOG.md


--------------------------------------


v2.8.0

# Sprint detail
This version is being released as part of  Sprint <>.
Jira Bug [SKY-7877]: https://<company-name>jira.atlassian.net/browse/SKY-7877

# Changes included
This version of microservice includes this change.
- Installation of Sentinel Agent.

#### Change 1 - Installing Sentinel Agent
Additionally, this microservice includes a functionality to install Sentinel agent in linux instance through userdata scripts.

##### Technical Notes
 Development team hasnt added any additional variable in the tfvars file of this microservice


##  Changes in Inputs  
no change in Input


##  Changes in Outputs 
No changes included in existing outputs.

# Link to Changelog
To learn more about all changes included, please visit [here]: https://git.cnvrmedia.net/projects/LMD/repos/terraform-aws-standard-linux-server/browse/CHANGELOG.md




V2.6.1

# Sprint detail
This version is being released as part of  Q2 Sprint 6.
Jira Bug [SKO-9516]: https://<company-name>jira.atlassian.net/browse/SKO-9516

# Changes included
This version of microservice is a hotfix to reduce the memory utilization of filebeat due to sparse files.
- Added tallylog and maillog in exclude of filebeat.yml file

 
##### Technical Notes
 Development team has added few sparse files in exclude to reduce the memory utilization.

##  Changes in Inputs  
No changes included in existing outputs.

##  Changes in Outputs 
No changes included in existing outputs.

# Link to Changelog
To learn more about all changes included, please visit [here]: https://bitbucket.<company-name>cnvrdevops.com/projects/LMD/repos/terraform-aws-standard-linux-server/browse/CHANGELOG.md

--------------------------------------------------------------


V2.6.0

# Sprint detail
This version is being released as part of  Q2 Sprint 2.
Jira Bug [SKY-8176]: https://<company-name>jira.atlassian.net/browse/SKY-8176

 

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

# Link to Changelog
To learn more about all changes included, please visit [here]: https://bitbucket.<company-name>cnvrdevops.com/projects/LMD/repos/terraform-aws-standard-linux-server/browse/CHANGELOG.md

-------------------------------------------------------------------------------------
 

v2.5.2

# Sprint detail
This version is being released as part of  Q2 Sprint 2.
Jira Bug [SKY-8447]: https://<company-name>jira.atlassian.net/browse/SKY-8447

# Changes included
This version of microservice includes this change.
- Added fix for sumologic secret fetch not using us-east-1
- Added fix for minor formatting issue in AWS_CLI script

##### Technical Notes
 Development team has modified the sumologic script to fetch the secret from the us-east-1 region only, as it doesn't exist in other regions.
We have also fixed an issue in the AWS_CLI script that forced the cli to be reinstalled on every run.


##  Changes in Inputs  
No changes included in existing inputs

# Link to Changelog
To learn more about all changes included, please visit [here]: https://bitbucket.<company-name>cnvrdevops.com/projects/LMD/repos/terraform-aws-standard-linux-server/browse/CHANGELOG.md

 

--------------------------------------

v2.5.0

# Sprint detail
This version is being released as part of  Q2 Sprint 2.
Jira Bug [SKY-7876]: https://<company-name>jira.atlassian.net/browse/SKY-7876

# Changes included
This version of microservice includes this change.
- Added Opsramp PCI auditable flag in tags.

#### Change 1 - Added Opsramp PCI auditable flag in tags
This microservice includes an instance_tags parameter that adds Opsramp PCI flag set to "N" in all linux instance.

##### Technical Notes
 Development team has added the below variable in the tfvars file of this microservice
| Variable Name | Default Value | Description |
|:--------------:|:---------------------:|:-----------:|
|instance_tags| null | Add tags like Opsramp Auditable (PCI) flag and infraMgmt flag that are attached to all linux instances |


##  Changes in Inputs  
The below table list the changes made to the inputs accepted by this microservice.

Following inputs have been added with this release

| Name          | Description           | Type  | Default | Required |
| ------------- |:---------------------:| -----:| -------:| --------:|
| instance_tags        | tags that are attached to all linux instances and includes auditable PCI flag | map(string) | null | yes |


##  Changes in Outputs 
No changes included in existing outputs.

# Link to Changelog
To learn more about all changes included, please visit [here]: https://bitbucket.<company-name>cnvrdevops.com/projects/LMD/repos/terraform-aws-standard-linux-server/browse/CHANGELOG.md

-------------------------------------------------------------------------------------


v2.4.1

# Sprint detail
This version is being released as part of  Sprint <>.
Jira Bug [SKY-7814]: https://<company-name>jira.atlassian.net/browse/SKY-7814

# Changes included
This version of microservice includes this change.
- Installation of Rapid7 Agent.

#### Change 1 - Installing Rapid7 Agent
Additionally, this microservice includes a functionality to install rapid7 agent in linux instance through userdata scripts.

##### Technical Notes
 Development team has added the below variable in the tfvars file of this microservice
| Variable Name | Default Value | Description |
|:--------------|:--------------------- |:-----------|
|default_linux_server_example_install_rapid7| false | Setting a value will tell the user data scripts to install rapid7 agent or not|


##  Changes in Inputs  
The below table list the changes made to the inputs accepted by this microservice.

Following inputs have been added with this release

| Name          | Description           | Type  | Default | Required |
| ------------- |:---------------------:| -----:| -------:| --------:|
| install_rapid7        | Flag for installing Rapid7 agent | string | false | yes |


##  Changes in Outputs 
No changes included in existing outputs.

# Link to Changelog
To learn more about all changes included, please visit [here]: https://bitbucket.<company-name>cnvrdevops.com/projects/LMD/repos/terraform-aws-standard-linux-server/browse/CHANGELOG.md


#  Usage  
```
- terraform init && terraform plan
- terraform apply     

module "standard-linux-server" {
  source  = "tfe.<company-name>cnvrdevops.com/_Development/standard-linux-server/aws"
  version = "2.4.1"

  install_rapid7 = var.install_rapid7
}
```
# Consuming this microservice
Please ensure that appropriate Go-CD pipeline is updated to pass the additional variables as described in the "changes in input" section above.

# Reference
Microservice to create a Standard Linux Server in AWS.

These resources are included:

* [Instance](https://www.terraform.io/docs/providers/aws/r/instance.html)
* [Security Group](https://www.terraform.io/docs/providers/aws/r/security_group.html)
* [ IAM Role](https://app.terraform.io/app/Dev<company-name>/modules/view/iam-role)
