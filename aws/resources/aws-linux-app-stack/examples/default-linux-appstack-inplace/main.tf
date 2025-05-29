module "_ops_params" {
  source = "git::ssh://<your-git-repo-url-here>/lm/terraform-aws-ops-params.git?ref=v2.0.0"
  
  providers = {
    aws = aws.master
  }

  access_key = var.master_access_key
  secret_key = var.master_secret_key
  token      = var.master_token

  db_instance_size = "m5.large"
  tenant_region    = var.master_region
}

module "default_linux_appstack_ex" {
  source = "../../"                        
								           
  region                                   = var.region
  access_key                               = var.access_key
  secret_key                               = var.secret_key
  token                                    = var.token
  
  depends_id                               = "TEST"
  resource_name_prefix                     = var.default_linux_appstack_ex_resource_name_prefix
  vpc_id                                   = var.default_linux_appstack_ex_vpc_id
  image_id                                 = var.default_linux_appstack_ex_image_id
  instance_type                            = var.default_linux_appstack_ex_instance_type
  key_name                                 = var.default_linux_appstack_ex_key_name
  root_block_device                        = var.default_linux_appstack_ex_root_block_device
  block_device_mappings                    = var.default_linux_appstack_ex_block_device_mappings
  service_instance_profile_name            = var.default_linux_appstack_ex_service_instance_profile_name
  private_subnets                          = var.default_linux_appstack_ex_private_subnets
								           
	deployment_type                          = var.default_linux_appstack_ex_deployment_type							           
  min_size                                 = var.default_linux_appstack_ex_min_size
  max_size                                 = var.default_linux_appstack_ex_max_size
  desired_capacity                         = var.default_linux_appstack_ex_desired_capacity
  target_group_arns                        = var.default_linux_appstack_ex_target_group_arn
								           
  client_code                              = var.default_linux_appstack_ex_client_code
  tenant_code                              = var.default_linux_appstack_ex_tenant_code
  tenant_environment                       = var.default_linux_appstack_ex_tenant_environment
  tenant_environment_sequence              = var.default_linux_appstack_ex_tenant_environment_sequence
  
  tenant_sumo_logic_secret_id              = var.default_tenant_sumo_logic_secret_id
  artifacts_store_location                 = var.default_linux_appstack_ex_artifacts_store_location
  source_s3_bucket                         = var.default_linux_appstack_ex_source_s3_bucket
  source_s3_object_key                     = var.default_linux_appstack_ex_source_s3_object_key
  service_role_arn                         = var.default_linux_appstack_ex_service_role_arn
  tenant_s3_artifact_customscript          = var.default_tenant_s3_artifact_customscript
  resource_stack_vas_ou                    = var.default_tenant_resource_stack_vas_ou

  lifecycle_hook                           = var.default_linux_appstack_ex_lifecycle_hook
  scale_up_policy                          = var.default_linux_appstack_ex_scale_up_policy
  scale_down_policy                        = var.default_linux_appstack_ex_scale_down_policy
  scheduled_action                         = var.default_linux_appstack_ex_scheduled_action
  cpu_upscaling_alarm                      = var.default_linux_appstack_ex_cpu_upscaling_alarm
  cpu_downscaling_alarm                    = var.default_linux_appstack_ex_cpu_downscaling_alarm
  memory_upscaling_alarm                   = var.default_linux_appstack_ex_memory_upscaling_alarm
  memory_downscaling_alarm                 = var.default_linux_appstack_ex_memory_downscaling_alarm
 
  autoscaling_notification_topic_arn       = var.default_linux_appstack_ex_autoscaling_notification_topic_arn
  
  health_check_type                        = var.default_linux_appstack_ex_health_check_type
  launch_template_version                  = var.default_linux_appstack_ex_launch_template_version
  spot_instance_types                      = var.default_linux_appstack_ex_spot_instance_types
  on_demand_percentage_above_base_capacity = var.default_linux_appstack_ex_on_demand_percentage_above_base_capacity
  spot_max_price                           = var.default_linux_appstack_ex_spot_max_price
  spot_notification_email_addresses        = var.default_linux_appstack_spot_notification_email_addresses
 
  kafka_elb_endpoint                       = var.default_linux_appstack_kafka_elb_endpoint
  install_rapid7                           = var.default_linux_appstack_ex_install_rapid7
  install_sentinelone	      			         = var.default_linux_server_example_install_sentinelone

  os_flavour                               = var.default_linux_appstack_ex_os_flavour
  
  tags                                     = var.default_linux_appstack_ex_tags
  asg_tags                                 = var.default_linux_appstack_ex_asg_tags
  tenant_kafka_beat_topic                  = var.tenant_kafka_beat_topic
  tenant_kafka_configuration_version       = var.tenant_kafka_configuration_version
  tenant_kafka_metricbeat_topic            = var.tenant_kafka_metricbeat_topic
  tenant_kafka_metricbeat_configuration_version = var.tenant_kafka_metricbeat_configuration_version
  recycle_asg   =  var.default_linux_appstack_ex_recycle_asg

  tenant_trend_api_username                = lookup(module._ops_params._ops_common_params_map, "trend_api_username", "")
  tenant_trend_api_password                = lookup(module._ops_params._ops_common_params_map, "trend_api_password", "")
  tenant_vas_username                      = lookup(module._ops_params._ops_common_params_map, "vas_username", "")
  tenant_vas_password                      = lookup(module._ops_params._ops_common_params_map, "vas_password", "") 
  tenant_trend_api_auth_secret             = lookup(module._ops_params._ops_common_params_map, "trend_api_auth_secret", "") 
}

