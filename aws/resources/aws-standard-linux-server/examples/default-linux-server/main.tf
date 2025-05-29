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

module "_ssh_key" {
  source = "git::ssh://<your-git-repo-url-here>/lmd/terraform-aws-ssh-key-local-file.git?ref=v2.1.0"
  
  providers = {
    aws = aws.master
  }
  
  aws_secret_name = var.default_linux_server_example_key_name
  aws_secret_key_pair_name = var.aws_secret_key_pair_name
  key_file_name = "${var.default_linux_server_example_key_name}.pem"
  fully_qualified_key_file_path = path.root
}

module "default_linux_server_example" {
  source = "../../"

  region                      = var.region
  resource_name_prefix        = var.default_linux_server_example_resource_name_prefix
  subnet_id                   = var.default_linux_server_example_subnet_id
  ami_id                      = var.default_linux_server_example_ami_id
  instance_type               = var.default_linux_server_example_instance_type
  associate_public_ip_address = var.default_linux_server_example_associate_public_ip_address
  key_name                    = var.default_linux_server_example_key_name

  host_name                    = var.default_linux_server_example_host_name
  tenant_code                  = var.default_linux_server_example_tenant_code
  client_code                  = var.client_code
  tenant_environment           = var.default_linux_server_example_tenant_environment
  tenant_environment_sequence  = var.default_linux_server_example_tenant_environment_sequence
  custom_script_s3_bucket_name = var.default_windows_server_example_custom_script_s3_bucket_name
  custom_script_s3_bucket_key  = var.default_windows_server_example_custom_script_s3_bucket_key
  instance_profile_name        = var.default_linux_server_example_instance_profile_name
  ebs_volumes                 = var.default_linux_server_example_ebs_volumes
  kafka_elb_endpoint          = var.default_linux_server_example_kafka_elb_endpoint
  install_rapid7              = var.default_linux_server_example_install_rapid7
  install_sentinelone	        = var.default_linux_server_example_install_sentinelone
  device_names	              = var.default_linux_server_example_device_names    
  tags                        = var.default_linux_server_example_tags
  instance_tags               = var.default_linux_server_example_instance_tags
  tenant_trend_api_username   = lookup(module._ops_params._ops_common_params_map, "trend_api_username", "")
  tenant_trend_api_password   = lookup(module._ops_params._ops_common_params_map, "trend_api_password", "")
  tenant_vas_username         = lookup(module._ops_params._ops_common_params_map, "vas_username", "")
  tenant_vas_password         = lookup(module._ops_params._ops_common_params_map, "vas_password", "") 
  tenant_trend_api_auth_secret = lookup(module._ops_params._ops_common_params_map, "trend_api_auth_secret", "") 
}

