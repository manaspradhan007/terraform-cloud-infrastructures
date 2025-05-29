##########
# Common #
##########

variable "default_linux_appstack_ex_vpc_id" {
  description = "VPC_ID"
}

variable "default_linux_appstack_ex_resource_name_prefix" {
  description = "Name prefix to be used to derive names for all the resources."
}

variable "default_linux_appstack_ex_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
}

variable "default_linux_appstack_ex_asg_tags" {
  description = "A list of map of tags to add to all resources."
}

############
# Userdata #
############
variable "default_linux_appstack_ex_client_code" {
  description = "Client code"
}

variable "default_linux_appstack_ex_tenant_code" {
  description = "Tenant code"
}

variable "default_linux_appstack_ex_tenant_environment" {
  description = "Environment of the tenant"
}

variable "default_linux_appstack_ex_tenant_environment_sequence" {
  description = "Environment Sequence of the tenant"
}

variable "default_tenant_s3_artifact_customscript" {
  description = "Customscript name with s3 bucket path"
}

variable "default_tenant_resource_stack_vas_ou" {
  description = "Resource Stack VAS OU"
  default     = "api"
}

variable "default_tenant_sumo_logic_secret_id" {
  description = "Tenant sumo logic secret id"
}

variable "default_linux_appstack_ex_install_rapid7" {
  default     = false
}
variable "default_linux_server_example_install_sentinelone" {
  default     = false
}

variable "default_linux_appstack_ex_os_flavour" {
  description = "OS flavour type"
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


###################
# Launch template #
###################
variable "default_linux_appstack_ex_image_id" {
  description = "The EC2 image ID to launch"
}

variable "default_linux_appstack_ex_instance_type" {
  description = "The type of instance to start."
}

variable "default_linux_appstack_ex_key_name" {
  description = "The key name that should be used for the instance"
}

variable "default_linux_appstack_ex_root_block_device" {
  description = "Root block device size and type"
  type        = map(string)
}

variable "default_linux_appstack_ex_block_device_mappings" {
  description = "Configure additional volumes of the instance besides specified by the AMI"
  type   = list(any)
    default = []
}

#####################
# Autoscaling Group #
#####################
variable "default_linux_appstack_ex_scale_up_policy" {
  description = "A map of tags to add to scaling policy resources for ASG."
  type        = list(any)
  default     = []
}
variable "default_linux_appstack_ex_scale_down_policy" {
  description = "A map of tags to add to scaling policy resources for ASG."
  type        = list(any)
  default     = []
}

variable "default_linux_appstack_ex_cpu_upscaling_alarm" {
  description = "A map of tags to add to all resources for CPU based scaling in ASG."
  type        = list(any)
  default     = []
}

variable "default_linux_appstack_ex_cpu_downscaling_alarm" {
  description = "A map of tags to add to all resources for CPU based scaling in ASG."
  type        = list(any)
  default     = []
}

variable "default_linux_appstack_ex_scheduled_action" {
  description = "A map of tags to add to all resources for ASG based scheduled actions."
  type        = list(any)
  default     = []
}

variable "default_linux_appstack_ex_memory_upscaling_alarm" {
  description = "A map of tags to add to all resources for memory based scaling in ASG."
  type        = list(any)
  default     = []
}

variable "default_linux_appstack_ex_memory_downscaling_alarm" {
  description = "A map of tags to add to all resources for memory based scaling in ASG."
  type        = list(any)
  default     = []
}

variable "default_linux_appstack_ex_autoscaling_notification_topic_arn" {
  description = "A resource arn for having the notification sent to the client teams."
  default     = ""
}

variable "default_linux_appstack_ex_min_size" {
  description = "The minimum size of the auto scale group"
}

variable "default_linux_appstack_ex_max_size" {
  description = "The maximum size of the auto scale group"
}

variable "default_linux_appstack_ex_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
}

variable "default_linux_appstack_ex_private_subnets" {
  description = "A list of private subnet ids inside the VPC"
  type        = list(string)
}

variable "default_linux_appstack_ex_target_group_arn" {
  type = list(string)
}


variable "default_linux_appstack_ex_lifecycle_hook" {
  description = "Lifecycle Hooks for ASG Group"
  type        = list(any)
  default = []
}


variable "default_linux_appstack_ex_health_check_type" {
  description = "\"EC2\" or \"ELB\". Controls how health checking is done"
  default     = "ELB"  
}

variable "default_linux_appstack_ex_launch_template_version" {
  description = "Template version. Can be Version Number, $Latest, or $Default."
  default     = "$Latest"
}

variable "default_linux_appstack_ex_spot_instance_types" {
  description = "Instance Types for Spot Fleet"
  type        = list(string)
  default     = []
}

variable "default_linux_appstack_ex_on_demand_allocation_strategy" {
  description = "Strategy to use when launching on-demand instances."
  default     = "prioritized"
}

variable "default_linux_appstack_ex_on_demand_base_capacity" {
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances."
  default     = 0
}

variable "default_linux_appstack_ex_on_demand_percentage_above_base_capacity" {
  description = "Percentage split between on-demand and Spot instances above the base on-demand capacity."
  default     = 0
}

variable "default_linux_appstack_ex_spot_allocation_strategy" {
  description = "How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized."
  default     = "lowest-price"
}

variable "default_linux_appstack_ex_spot_instance_pools" {
  description = "Number of Spot pools per availability zone to allocate capacity. EC2 Auto Scaling selects the cheapest Spot pools and evenly allocates Spot capacity across the number of Spot pools that you specify."
  default     = 2
}

variable "default_linux_appstack_ex_spot_max_price" {
  description = "Maximum price per unit hour that the user is willing to pay for the Spot instances. Default: an empty string which means the on-demand price."
  default     = ""
}
variable "default_linux_appstack_spot_notification_email_addresses" {
  description = "email adresses that needs to be notified when a spot instance is about to go down"
  type        = list(string)
  default     = []
}

################
# CodePipeline #
################

variable "default_linux_appstack_ex_deployment_type" {
  description = "IN_PLACE or BLUE_GREEN"
}
variable "default_linux_appstack_ex_artifacts_store_location" {
  description = "The location where AWS CodePipeline stores artifacts for a pipeline, such as an S3 bucket"
  default     = ""
}

variable "default_linux_appstack_ex_source_s3_bucket" {
  description = "The location for AWS CodePipeline source S3 bucket"
  default     = ""
}

variable "default_linux_appstack_ex_source_s3_object_key" {
  description = "The location for AWS CodePipeline source S3 object key"
  default     = ""
}

variable "default_linux_appstack_ex_service_role_arn" {
  description = "."
}

variable "default_linux_appstack_ex_service_instance_profile_name" {
  description = "."
  default     = ""
}
variable "default_linux_appstack_ex_create_codedeploy" {
  default     = true
}
################
## ELK Hosts ##
################

variable "default_linux_appstack_kafka_elb_endpoint" {
  description = "kafka ELB Endpoint"
} 

variable "default_linux_appstack_ex_recycle_asg" {
  default = false
}
