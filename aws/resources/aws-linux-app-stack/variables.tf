##########
# Common #
##########

variable "depends_id" {
  description = "depends_id for ASG and code pipeline"
}

variable "vpc_id" {
  description = "VPC_ID"
  default     = ""
}

variable "execute_microservice" {
  description = "Main switch to control the execution of this microservice based on consumer logic."
  default     = true
}

variable "create_security_group" {
  description = "Main switch to control the execution of this microservice based on consumer logic."
  default     = true
}

variable "resource_name_prefix" {
  description = "Name prefix to be used to derive names for all the resources."
  default     = ""
}

variable "service_instance_profile_name" {
  description = "The Name of the Service Instance Profile."
}

variable "install_rapid7" {
  description = "Flag for installing Rapid7 agent on the server."
  default     = false
}


variable "install_sentinelone" {
  description = "Flag for installing sentinelone agent on the server."
  default     = false
}

variable "recycle_asg" {
  description =" Flag for recycling asg."
  default =  false
}

variable "region" {
  description = "Region"
}

variable "access_key" {
}


variable "secret_key" {
}

variable "token" {
}

##################
# Security Group #
##################
variable "sg_ids" {
  description = "List of IDs of the Security Groups for the Auto scaling group Launch Configuration . One will be created if empty."
  default     = []
}

variable "asg_dereg_lambda_sg_ids" {
  description = "Security group ID for the Dereg Lambda function. Will use previously created or specified security groups if empty"
  default     = []
}

variable "default_asg_sg_ingress_rules" {
  description = "List of ingress rule for Auto scaling group"
  type        = list(any)
  default = [
    {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["10.253.32.0/20"]
      description = "CSE Access"
    },
  ]
}

variable "default_asg_sg_egress_rules" {
  description = "List of egress rule for Auto scaling group"
  type        = list(any)
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

#################
# Launch Config #
#################
variable "image_id" {
  description = "The EC2 image ID to launch"
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to start."
  default     = ""
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  default     = ""
}

variable "enable_monitoring" {
  description = "Controls if the detailed monitoring should be enabled."
  default     = false
}

variable "root_block_device" {
  description = "Root block device size and type"
  type        = map(string)
  default     = {}
}
variable "block_device_mappings" {
  description = "Configure additional volumes of the instance besides specified by the AMI"
  type   = list(any)
    default = []
}

variable "update_default_launch_template_version" {
  description = "Updates the default Version of launch templte on each update."
  default     = true
}

#####################
# Autoscaling Group #
#####################
variable "scale_up_policy" {
  description = "A map of tags to add to all resources for ASG policies."
  type        = list(any)
}

variable "scale_down_policy" {
  description = "A map of tags to add to all resources for ASG policies."
  type        = list(any)
}

variable "scheduled_action" {
  description = "A map of tags to add to all resources for ASG scheduled actions. NOTE: When start_time and end_time are specified with recurrence , they form the boundaries of when the recurring action will start and stop."
  type        = list(any)
  default     = []
}

variable "cpu_upscaling_alarm" {
  description = "A map of tags to add to all resources for CPU based scaling in ASG."
  type        = list(any)
}

variable "cpu_downscaling_alarm" {
  description = "A map of tags to add to all resources for CPU based scaling in ASG."
  type        = list(any)
}


#ASG Memory Based Scaling
variable "memory_downscaling_alarm" {
  description = "A map of tags to add to all resources for memory based scaling in ASG."
  type        = list(any)
  default     = []
}

variable "memory_upscaling_alarm" {
  description = "A map of tags to add to all resources for memory based scaling in ASG."
  type        = list(any)
  default     = []
}

variable "autoscaling_notification_topic_arn" {
  description = "A resources arn for having the notification sent to the client teams."
  default     = ""
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
  default     = 0
}

variable "max_size" {
  description = "The maximum size of the auto scale group"
  default     = 0
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  default     = 0
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = 600
}

variable "health_check_type" {
  description = "\"EC2\" or \"ELB\". Controls how health checking is done"
  default     = "ELB"
}

variable "private_subnets" {
  description = "A list of private subnet ids inside the VPC"
}

variable "target_group_arns" {
  description = "A list of target group which need to be attached in auto scaling"
  type        = list(string)
  default     = []
}

variable "lifecycle_hook" {
  description = "Lifecycle Hooks for ASG Group"
  type        = list(any)
  default     = []
} 

##############################
# Autoscaling Group Policies #
##############################
variable "cpu_high_comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold"
  default     = "GreaterThanThreshold"
}

variable "memory_high_comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold"
  default     = "GreaterThanOrEqualToThreshold"
}

variable "memory_low_comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold"
  default     = "LessThanThreshold"
}

variable "cpu_low_comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold"
  default     = "LessThanThreshold"
}

#Launch Template
variable "launch_template_version" {
  description = "Template version. Can be Version Number, $Latest, or $Default."
  default     = "$Latest"
}

variable "spot_instance_types" {
  description = "Instance Types for Spot Fleet"
  type        = list(string)
  default     = []
}

variable "spot_notification_email_addresses" {
  description = "email adresses that needs to be notified when a spot instance is about to go down"
  type        = list(string)
  default     = []
}

variable "on_demand_allocation_strategy" {
  description = "Strategy to use when launching on-demand instances."
  default     = "prioritized"
}

variable "on_demand_base_capacity" {
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances."
  default     = 0
}

variable "on_demand_percentage_above_base_capacity" {
  description = "Percentage split between on-demand and Spot instances above the base on-demand capacity."
  default     = 0
}

variable "spot_allocation_strategy" {
  description = "How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized."
  default     = "lowest-price"
}

variable "spot_instance_pools" {
  description = "Number of Spot pools per availability zone to allocate capacity. EC2 Auto Scaling selects the cheapest Spot pools and evenly allocates Spot capacity across the number of Spot pools that you specify."
  default     = 2
}

variable "spot_max_price" {
  description = "Maximum price per unit hour that the user is willing to pay for the Spot instances. Default: an empty string which means the on-demand price."
  default     = ""
}
###############################
# CodeDeploy and CodePipeLine #
###############################
variable "create_codedeploy" {
  description = "Controls if CodeDeploy should be created."
  default     = true
}

variable "enable_codedeploy_check" {
  description = "Controls if CodeDeploy Check should be run."
  default     = true
}

variable "service_role_arn" {
  description = "Service role ARN for codedeploy and codepipeline"
}

variable "codedeploy_compute_platform" {
  description = "The compute platform can either be ECS, Lambda, or Server. Default is Server"
  default     = "Server"
}

variable "deployment_config_name" {
  description = "The name of the group's deployment config"
  default     = "CodeDeployDefault.AllAtOnce"
}

variable "deployment_type" {
  description = "Indicates whether to run an IN_PLACE deployment or a BLUE_GREEN deployment"
  default     = "IN_PLACE"
}

variable "deployment_option" {
  description = "Indicates whether to route deployment traffic behind a load balancer. deployment_type is BLUE_GREEN then use WITH_TRAFFIC_CONTROL,deployment_type is IN_PLACE then use WITHOUT_TRAFFIC_CONTROL"
  default     = "WITHOUT_TRAFFIC_CONTROL"
}

variable "artifacts_store_location" {
  description = "The location where AWS CodePipeline stores artifacts for a pipeline, such as an S3 bucket"
  default     = ""
}

variable "source_s3_bucket" {
  description = "The location for AWS CodePipeline source S3 bucket"
  default     = ""
}

variable "source_s3_object_key" {
  description = "The location for AWS CodePipeline source S3 object key"
  default     = ""
}

variable "rollback_option" {
  description = "Disable or enable codedeploy rollback in case of failure"
  default     = true
}
############
# Userdata #
############
variable "client_code" {
  description = "Client code"
}

variable "tenant_code" {
  description = "Tenant code"
}

variable "tenant_trend_api_url" {
  description = "Tenant trend api url"
  default     = "cse-east-trend.com"
}

variable "tenant_trend_api_username" {
  description = "Tenant trend api url api username"
}

variable "tenant_trend_api_password" {
  description = "Tenant trend api password"
}

variable "tenant_trend_api_auth_secret" {
  description = "Tenant trend api auth secret"
}

variable "tenant_trend_cloud_account_name" {
  description = "Tenant trend api cloud account name"
  default     = "prov-dev-1"
}

variable "kafka_elb_endpoint" {
  description = "kafka ELB Endpoint"
  default     = "kelk-dev-kafka.lowerenv.com"
} 

variable "tenant_environment" {
  description = "Environment of the tenant"
}

variable "master_tenant_environment" {
  description = "Environment of the master tenant"
  default="DEV"
}

variable "tenant_environment_sequence" {
  description = "The user data to provide when launching the instance"
  default     = "1"
}

variable "tenant_vas_username" {
  description = "Tenant VAS username"
}

variable "tenant_vas_password" {
  description = "Tenant VAS password"
}

variable "resource_stack_vas_ou" {
  description = "Resource Stack VAS OU"
  default     = "api"
}

variable "tenant_sumo_logic_secret_id" {
  description = "Tenant sumo logic secret id"
  default     = "arn:aws:secretsmanager:us-east-1:348141368423:secret:Sumo_Logic_Agent_Access-lLKOgn"
}

variable "tenant_s3_artifact_customscript" {
  description = "Customscript name with s3 bucket path"
}

variable "os_flavour" {
  description = "os flavour type"
  default     = "RHEL"
}
variable "tenant_kafka_beat_topic" {
  description = "tenant kafka beat topic"
  default     = "oslogs"
}
variable "tenant_kafka_configuration_version" {
  description = "tenant kafka configuration version"
  default     = "0.11.0.0"
}
variable "tenant_kafka_metricbeat_topic" {
  description = "tenant kafka metric beat topic"
  default     = "metricbeat"
}
variable "tenant_kafka_metricbeat_configuration_version" {
  description = "tenant kafka metric beat configuration version"
  default     = "0.11.0.0"
}


########
# Tags #
########
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "asg_tags" {
  description = "A list of map of tags to Auto scaling group."
  type        = list(any)
  default     = []
}

