#############
# Providers #
#############
region     = "<ENTER REGION>"
access_key = "<ENTER ACCESS KEY>"
secret_key = "<ENTER SECRET KEY>"
token      = "<ENTER TOKEN>"

master_region     = "<insert master region here>"
master_access_key = "<insert master access_key here>"
master_secret_key = "<insert master secret_key here>"
master_token      = "<insert master token here>"

##########
# Common #
##########
default_linux_appstack_ex_vpc_id                = "vpc-0b5b83654b21c079c"
default_linux_appstack_ex_private_subnets       = ["subnet-037a9a3d2249b596a", "subnet-0a74a146e1e37a0b1"]
default_linux_appstack_ex_resource_name_prefix 	= "IP-INPLACE"
default_linux_appstack_ex_tags					        = { "TenantCode" = "D1IPV1", "UserName" = "inspecpipeline" }
default_linux_appstack_ex_asg_tags              = [ 
    { key = "0050:InfraMgmt", value = "", propagate_at_launch = true },
    { key = "0600:Auditable (PCI)", value = "N", propagate_at_launch = true }
]


#ASG Launch Template
default_linux_appstack_ex_image_id				      = "ami-03715656f06ffd8d0"
default_linux_appstack_ex_instance_type			    = "t2.medium"
default_linux_appstack_ex_key_name				      = "Ansible"
default_linux_appstack_ex_root_block_device		  = {

  device_name = "/dev/sda1"
	volume_type	= "gp2"
	volume_size	= 150
}
default_linux_appstack_ex_block_device_mappings = [
    {
      device_name    = "/dev/sdc"
      ebs = {
        volume_type   = "io1"
        volume_size     = 100
        iops = 4000}
    }
]
######################
# Auto Scaling Group #
######################
default_linux_appstack_ex_deployment_type                  = "IN_PLACE"
default_linux_appstack_ex_target_group_arn                 = ["arn:aws:elasticloadbalancing:us-east-1:454125583165:targetgroup/D1SKUN-AL-PUB-API-EXT-TG/848de7d3d3444ce7"]
default_linux_appstack_ex_spot_instance_types              = ["t2.large", "t2.medium", "m4.large", "m4.xlarge"]
default_linux_appstack_spot_notification_email_addresses   = ["<email here>"]
default_linux_appstack_ex_lifecycle_hook	                 = [
    {
      name              = "De-Registration"
      default_result    = "CONTINUE"
      heartbeat_timeout     = 180
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata = <<EOF
{
  "De-Register": "Generic"
}
EOF

    }
  ]

default_linux_appstack_ex_min_size                         = 1
default_linux_appstack_ex_max_size                         = 1
default_linux_appstack_ex_desired_capacity                 = 1

default_linux_appstack_ex_scale_up_policy = [

 {

   name = "scale-up-policy"

   scaling_adjustment = 1

   cooldown = 300

 },

 {

   name = "scale-up-policy-1"

   scaling_adjustment = 1

   cooldown = 300

 },

]



default_linux_appstack_ex_scale_down_policy = [

 {

   name = "scale-down-policy"

   scaling_adjustment = -1

   cooldown = 300

 },

 {

   name = "scale-down-policy-1"

   scaling_adjustment = -1

   cooldown = 300

 },

]


default_linux_appstack_ex_cpu_upscaling_alarm   = [
 {
   alarm_name = "CPU-Utilization_Scaling_UP_API"
   period = "300"
   threshold = "70"
 },
]

default_linux_appstack_ex_cpu_downscaling_alarm = [
 {
   alarm_name = "CPU-Utilization_Scaling_DOWN_API"
   period = "300"
   threshold = "40"
 },
]


#Not mandatory
#ASG Scheduled Actions
default_linux_appstack_ex_scheduled_action = [
 {
   scheduled_action_name = "scheduled_actions"
   min_size = 1
   max_size = 2
   desired_capacity = 2
   start_time = "2021-12-11T18:00:00Z"
   end_time = "2021-12-12T06:00:00Z"
   recurrence = "0 * * * *"
 },
]

#ASG Memory Based Scaling
default_linux_appstack_ex_memory_upscaling_alarm   = [
 {
   alarm_name = "VirtualMemory-Utilization_Scaling_UP_API"
   period = "300"
   threshold = "70"
 },
]
default_linux_appstack_ex_memory_downscaling_alarm = [
 {
   alarm_name = "VirtualMemory-Utilization_Scaling_DOWN_API"
   period = "300"
   threshold = "30"
 },
]

default_linux_appstack_ex_autoscaling_notification_topic_arn = ""

###############################################
# Code Deploy Deployment Group for BLUE_GREEN #
###############################################
default_linux_appstack_ex_artifacts_store_location	        = "d1skun-al-artifacts"
default_linux_appstack_ex_source_s3_bucket			            = "d1skun-al-artifacts"
default_linux_appstack_ex_source_s3_object_key		          = "api/D1SKUN-al-api-forge.zip"
default_linux_appstack_ex_service_role_arn                  = "arn:aws:iam::454125583165:role/D1SKUN-AL-SERVICE-CATTLE-ROLE"
default_linux_appstack_ex_service_instance_profile_name     = "D1SKUN-AL-SERVICE-CATTLE-INSTANCE-PROFILE"

####################
# Userdata Scripts #
####################
default_linux_appstack_ex_client_code 						          = "SKUN"
default_linux_appstack_ex_tenant_code 						          = "D1SKUN"
default_linux_appstack_ex_tenant_environment 				        = "DEV"
default_linux_appstack_ex_tenant_environment_sequence       = "1"
default_tenant_s3_artifact_customscript                     = ""
default_tenant_resource_stack_vas_ou                        = "api"
default_tenant_sumo_logic_secret_id                         = "arn:aws:secretsmanager:us-east-1:348141368423:secret:Sumo_Logic_Agent_Access-lLKOgn"
default_linux_appstack_ex_install_rapid7                    = false
default_linux_server_example_install_sentinelone			= false

default_linux_appstack_ex_os_flavour                        = "RHEL"  #RHEL or RHEL_ARM
tenant_kafka_beat_topic                                     ="oslog"
tenant_kafka_configuration_version                          ="0.11.0.0"
tenant_kafka_metricbeat_topic                               ="metricbeat"
tenant_kafka_metricbeat_configuration_version               ="0.11.0.0"

################
## ELK Hosts ##
################
default_linux_appstack_kafka_elb_endpoint                   = "kelk-dev-kafka.lowerenv.com"

################
## Flag to recycle ASG ##
################
default_linux_appstack_ex_recycle_asg                       = false