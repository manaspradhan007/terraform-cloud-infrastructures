# Application Load Balancer Microservice by 

Microservice to create an Application Load Balancer in AWS.


V2.4.0
 


 

# Changes included
Added target group deristration delay parameter

 
##### Technical Notes
 Development team has added the below variable in the tfvars file of this microservice
default_tg_deregistration_delay - Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds.

##  Changes in Inputs  
| Name                  | Description           | Type  | Default | Required |
| --------------------- |:---------------------:| -----:| -------:| --------:|
| default_tg_deregistration_delay |  Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds.         | number| 300     | no       |




##  Changes in Outputs 
No changes included in existing outputs.



V2.2.0
 


 

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

These resources are included:

* [ALB](https://www.terraform.io/docs/providers/aws/r/lb.html),
* [ALB Listeners (HTTP/HTTPS)](https://www.terraform.io/docs/providers/aws/r/lb_listener.html),
* [Target Group](https://www.terraform.io/docs/providers/aws/r/lb_target_group.html)
* [Security Group](https://www.terraform.io/docs/providers/aws/r/security_group.html).
