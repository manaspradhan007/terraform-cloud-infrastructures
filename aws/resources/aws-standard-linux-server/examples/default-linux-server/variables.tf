variable "default_linux_server_example_resource_name_prefix" {
}

variable "default_linux_server_example_subnet_id" {
}

variable "default_linux_server_example_ami_id" {
}

variable "default_linux_server_example_instance_type" {
  default = "t2.medium"
}

variable "default_linux_server_example_associate_public_ip_address" {
  default = false
}

variable "default_linux_server_example_host_name" {
}

variable "default_linux_server_example_tenant_code" {
}

variable "default_linux_server_example_tenant_environment" {
}

variable "default_linux_server_example_tenant_environment_sequence" {
}

variable "default_linux_server_example_install_rapid7" {
  default     = false
}
variable "default_linux_server_example_install_sentinelone" {
  default     = false
}


variable "default_linux_server_example_tags" {
  type = map(string)
}

variable "default_linux_server_example_instance_tags" {
  type = map(string)
}

variable "default_windows_server_example_custom_script_s3_bucket_name" {
  description = "name of the s3 bucket where the custom script resides"
  default     = ""
}

variable "default_windows_server_example_custom_script_s3_bucket_key" {
  description = "path of the script - usaully will be key/name and script should be a txt file with shell scipt in it"
  default     = ""
}

variable "client_code" {
  description = "Client Code"
}

variable "default_linux_server_example_key_name" {
  description = "The key name of the Key Pair to use for the instance."
}

variable "default_linux_server_example_kafka_elb_endpoint" {
  description = "kafka ELB Endpoint"
} 

variable "default_linux_server_example_instance_profile_name" {}

variable "default_linux_server_example_ebs_volumes" {
  description = "List of ebs volumes to be attached to the instance."
  default = []
}

###########
# SSH Key #
###########
variable "aws_secret_name" {
  description = "Name of the secret in aws where secret key pairs are stored"
  default = "dev"
}

variable "aws_secret_key_pair_name" {
  description = "Name of the aws secret key pair in secret string"
  default = "PrivateKey"
}

variable "key_file_name" {
  description = "name of the key file to be created"
  default = "dev.pem"
}

variable "fully_qualified_key_file_path" {
  description = "secret value to be used to create private key file with"
  default     = ""
}

variable "default_linux_server_example_device_names" {}