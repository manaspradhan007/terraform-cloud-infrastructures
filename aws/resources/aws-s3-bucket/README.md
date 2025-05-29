# Microservice Name
terraform-aws-s3-bucket
   
# Purpose
This microservice allows user to create 2 s3 buckets(backup and replication) and manage the lifecycle. 


v2.4.0

# Sprint detail
This version is being released as part of  Q2 Sprint 6.

# Changes included
This version of microservice includes this change.
- Added dynamic noncurrent_version_transition for lifecycle
- Added dynamic logging block for the s3 bucket
- Removed the aws provider version

##  Changes in Inputs 
Added the following inputs:
| Name | Description | Type | Default |
|:--------------|:------------- |:------------- |:------------- |
| add_noncurrent_version_transition | Set to true to add noncurrent_version_transition to the S3 bucket | bool | false |
| noncurrent_version_transition_days | Specifies the number of days noncurrent object versions transition | number | null |
| noncurrent_version_transition_storage_class | Specifies the Amazon S3 storage class to which you want the noncurrent object versions to transition | string | null |
| add_logging | Set to true to add logging to the S3 bucket | bool | false |
| log_target_bucket | The name of the bucket that will receive the log objects | string | null |
| log_target_prefix | To specify a key prefix for log objects | string | null |

##  Changes in Outputs 
No changes included in existing outputs.

##
# Link to Changelog
To learn more about all changes included, please visit [here]: https://bitbucket.<company-name>cnvrdevops.com/projects/LMD/repos/terraform-aws-s3-bucket/browse/CHANGELOG.md


v2.2.3

# Sprint detail
This version is being released as part of  Q4 Sprint 6.
Jira Task [SKY-9284]: https://jira.cnvrmedia.net/browse/SKY-9248

# Changes included
This version of microservice includes this change.
- Added kms key support.

##  Changes in Outputs 
No changes included in existing outputs.
##
# Link to Changelog
To learn more about all changes included, please visit [here]: https://bitbucket.<company-name>cnvrdevops.com/projects/LMD/repos/terraform-aws-s3-bucket/browse/CHANGELOG.md

----------------------------------------------------------------------------------

# Release version
v2.2.1-tfo

# Sprint detail
This version is being released as part of  Q4 Sprint 6.
Jira Task [SKY-9284]: https://jira.cnvrmedia.net/browse/SKY-9248

# Changes included
This version of microservice includes this change.
- Added kms key support.

##  Changes in Outputs 
No changes included in existing outputs.
##
# Link to Changelog
To learn more about all changes included, please visit [here]: https://bitbucket.<company-name>cnvrdevops.com/projects/LMD/repos/terraform-aws-s3-bucket/browse/CHANGELOG.md

----------------------------------------------------------------------------------


v2.0.13

# Sprint detail
This version is being released as part of  Q2 Sprint 6.

# Changes included
This version of microservice includes this change.
- The bucket policy of the replication bucket has been defaulted.

##  Changes in Inputs  
No changes included in existing inputs.

##  Changes in Outputs 
No changes included in existing outputs.

# Link to Changelog
To learn more about all changes included, please visit [here]: https://git.cnvrmedia.net/projects/LMD/repos/terraform-aws-s3-bucket/browse/CHANGELOG.md

----------------------------------------------------------------------------------


v2.0.12

# Sprint detail
This version is being released as part of  Q2 Sprint 3.
Jira Bug [SKY-8007]: https://<company-name>jira.atlassian.net/browse/SKY-8007

# Changes included
This version of microservice includes this change.
- Changes for move to glacier lifecycle settings
- Setting previous version unchecked for transition
- setting 180 days for expiration
- setting 1 day for previous version expiration days  
- setting 2 days for cleanup incomplete expiration days


##  Changes in Outputs 
No changes included in existing outputs.
##
# Link to Changelog
To learn more about all changes included, please visit [here]: https://bitbucket.<company-name>cnvrdevops.com/projects/LMD/repos/terraform-aws-oracle-on-linux/browse/CHANGELOG.md


v2.2.1-tfo

# Sprint detail
This version is being released as part of  Q4 Sprint 6.
Jira Bug [SKY-8834]: https://<company-name>jira.atlassian.net/browse/SKY-8834

# Changes included
This version of microservice includes this change.
- Changed source link pointing from TFE link to bitbucket link.

##  Changes in Outputs 
No changes included in existing outputs.
##
# Link to Changelog
To learn more about all changes included, please visit [here]: https://bitbucket.<company-name>cnvrdevops.com/projects/LMD/repos/terraform-aws-s3-bucket/browse/CHANGELOG.md


v2.0.12

# Sprint detail
This version is being released as part of  Q2 Sprint 3.
Jira Bug [SKY-8007]: https://<company-name>jira.atlassian.net/browse/SKY-8007

# Changes included
This version of microservice includes this change.
- Changes for move to glacier lifecycle settings
- Setting previous version unchecked for transition
- setting 180 days for expiration
- setting 1 day for previous version expiration days  
- setting 2 days for cleanup incomplete expiration days


##  Changes in Outputs 
No changes included in existing outputs.
##
# Link to Changelog
To learn more about all changes included, please visit [here]: https://bitbucket.<company-name>cnvrdevops.com/projects/LMD/repos/terraform-aws-oracle-on-linux/browse/CHANGELOG.md

------------------------------------------------------------------------    


v2.0.12

#  Usage  
```
- terraform init && terraform plan
- terraform apply     

module "oracle-on-linux" {
  source  = "tfe.<company-name>cnvrdevops.com/_Development/oracle-on-linux/aws"
  version = "2.0.12"

}
```
# Consuming this microservice
Please ensure that appropriate Go-CD pipeline is updated to pass the additional variables as described in the "changes in input" section above.

# Reference
Microservice to setup S3-bucket.

----------------------------------------------------------------------------------

These resources are included:

* [ S3 Bucket](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html)
* [ S3 Bucket Policy](https://www.terraform.io/docs/providers/aws/r/s3_bucket_policy.html)


Micro-services changed: S3 bucket(v2.0.12)
Motive : Implement glacier & deep archive lifecycle transition policy for S3 buckets.
Changes: 
•	Configuration of backup bucket is changed as follows: 
1.	Transition days defaulted to 8 days
2.	Storage class defaulted to DEEP_ARCHIVE
3.	Expiration days defaulted to 180 days
4. Previousversion expiration days defaulted to 1 day
5. cleanup incomplete expiration days to 2 days.

•	 Configuration of backup replication bucket is changed as follows: 
1.	Transition days defaulted to 0 days
2.	Storage class defaulted to null
3.	Expiration days defaulted to 180 days
4. cleanup incomplete expiration days to 2 days.

Variables added with default values of:
default_s3_bucket_example_add_lifecycle_policy               = false
default_s3_bucket_example_expiration_days                    = "180"
default_s3_bucket_example_previous_version_expiration_days   = "1"
default_s3_bucket_example_cleanup_incomplete_expiration_days = "2"
default_s3_bucket_example_storage_class                      = "GLACIER"
default_s3_bucket_example_transition_days                    = "30"
default_s3_bucket_example_lifecycle_policy_name              = "Move To Glacier"

