# Elasticache Resources Microservice by 

Microservice to create Elasticache Resources in AWS.


v2.3.5


# Changes included
This version of microservice includes this change.
- Added random keeper to force recreate on encryption change

##### Technical Notes
 Development team has fixed the issue of elasticache erroring due to a create before destroy when changing the rest encryption in a cattle provision with additional random keeper functionality.

This adds a random_id resource which will force a recreate on the elasticache resource when a change in at rest encryption is noticed. This will also change the tag "Name" with a random string added to the end of the resource name to further assure there are no issues in the recreate.

##  Changes in Inputs  
No changes included in existing outputs.

##  Changes in Outputs 
No changes included in existing outputs.




v2.3.4


# Changes included
This version of microservice includes this change.
- Fixed create before destroy issue when encryption at rest is changed

##### Technical Notes
 Development team has fixed the issue of elasticache erroring due to a create before destroy when changing the rest encryption in a cattle provision.

This issue is handled by giving the resource a dynamic name, which will change if encryption is changed. This forces terraform to create the new resource under a different name, hence avoiding the issue presented.

Change to name of the resource is as follows:
If the resource has encryption enables, the new format for the resource name will be:
{var.resource_name_prefix}-CLUSTER-e

if it is not encrypted, it will be:
{var.resource_name_prefix}-CLUSTER-ue

##  Changes in Inputs  
No changes included in existing outputs.

##  Changes in Outputs 
No changes included in existing outputs.





v2.3.3

# Changes included
This version of microservice includes this change.
- Fixed clustermode off issue
- Fixed issue with variables being string instead of bool

##### Technical Notes
 Development team has fixed the issue of resources being recreated when clustermode is set to off by adding a new cluster_mode_enabled variable that allows users to select which mode the resource should be built in.
This should prevent future issues of recreation when clustermode off resources are rerun.

We have also fixed issues with flag variables being treated as string instead of bool. This has been known to cause issues with conditions. This may need a fix from the customer in case they are currently using string.

##  Changes in Inputs  
The below table list the changes made to the inputs accepted by this microservice.

Following inputs have been added with this release

| Name         | Description           | Type  | Default | Required |
| ------------ |:---------------------:| -----:| -------:| --------:|
| cluster_mode_enabled | Flag to create cluster mode off or on resources | bool | true | no |

Following inputs have been changed with this release

| Name         | Description           | Type  | Default | Required |
| ------------ |:---------------------:| -----:| -------:| --------:|
| cache_num_node_groups | Variable now has no effect when cluster_mode is set to false. It will be taken as a default of 1 in this case. | int | 2 | no |

##  Changes in Outputs 
No changes included in existing outputs.




V2.3.2


# Changes included
This version of microservice includes this change.
- Fixed formatting of output which caused issues when cache_required set to false
 
##### Technical Notes
 Development team has fixed the outputs to use element(concat) to allow terraform to properly read the values when cache_required flag is set to false.

##  Changes in Inputs  
No changes included in existing outputs.

##  Changes in Outputs 
No changes included in existing outputs.






V2.1.0
 

 

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


v2.0.4

# Sprint details
This version is being released as part of  Q4 Sprint 1.
# Changes included
This version of microservice changes output.tf for Configuration Endpoint as output instead of Primary Endpoint

##### Technical Notes
 Development team has modified output.tf for Configuration Endpoint as output instead of Primary Endpoint

##  Changes in Inputs  
No changes included in existing inputs.

##  Changes in Outputs 
Configuration Endpoint as output instead of Primary Endpoint

------------------------------------------------------------------------   

These resources are included:

* [Security Group](https://www.terraform.io/docs/providers/aws/r/security_group.html)
* [Elasticache Subnet Group](https://www.terraform.io/docs/providers/aws/r/elasticache_subnet_group.html)
* [Elasticache Replication Group](https://www.terraform.io/docs/providers/aws/r/elasticache_replication_group.html)

