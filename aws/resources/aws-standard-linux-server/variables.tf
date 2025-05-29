##########
# Common #
##########
variable "execute_microservice" {
  description = "Main switch to control the execution of this microservice based on consumer logic."
  default     = true
}

variable "create_security_group" {
  description = "Main switch to control the creation of security group."
  default     = true
}

variable "resource_name_prefix" {
  description = "Name prefix to be used to derive names for all the resources."
}

variable "client_code" {
  description = "Client Code"
}

variable "kafka_elb_endpoint" {
  description = "kafka ELB Endpoint"
  default     = "kelk-dev-kafka.lowerenv.com"
}

variable "install_rapid7" {
  description = "Flag for installing Rapid7 agent on the server."
  default     = false
}

variable "install_sentinelone" {
  description = "Flag for installing sentinelone agent on the server."
  default     = false
}

variable "region" {
  description = "Flag for installing sentinelone agent on the server."
}

############
# Instance #
############
variable "subnet_id" {
  description = "The VPC Subnet ID to launch the Server in."
}

variable "ami_id" {
  description = "The ID of the AMI to use for the server."
}

variable "sg_ids" {
  type        = list(string)
  description = "List of Security Group IDs to associate the Server with. One will be created if empty."
  default     = []
}

variable "instance_profile_name" {
  description = "Name of the IAM Instance Profile to launch the Server with. One will be created if empty."
  default     = ""
}

variable "key_name" {
  description = "The key name of the Key Pair to use for the instance."
}

variable "instance_type" {
  description = "The type of instance to start."
  default     = "t2.micro"
}

variable "enable_monitoring" {
  description = "Controls if the detailed monitoring should be enabled."
  default     = false
}

variable "disable_api_termination" {
  description = "If true, enables the Instance Termination Protection."
  default     = false
}

variable "associate_public_ip_address" {
  description = "If true, associates a public ip address."
  default     = false
}

############
# Userdata #
############
variable "host_name" {
  description = "Host name of the server."
}

variable "tenant_code" {
  description = "The tenant code."
}

variable "tenant_environment" {
  description = "Environment of the tenant."
}

variable "master_tenant_environment" {
  description = "Environment of the master tenant."
  default="DEV"
}

variable "tenant_environment_sequence" {
  description = "Environment sequence of the tenant."
}

variable "tenant_vas_username" {
  description = "Tenant VAS username"
}

variable "tenant_vas_password" {
  description = "Tenant VAS password."
}

variable "tenant_sumo_logic_secret_id" {
  description = "Tenant sumo logic secret id"
  default     = "arn:aws:secretsmanager:us-east-1:348141368423:secret:Sumo_Logic_Agent_Access-lLKOgn"
}

variable "tenant_trend_api_url" {
  description = "Tenant trend api url."
  default     = "<url-here>"
}

variable "tenant_trend_api_auth_secret" {
  description = "Tenant trend api auth secret."
}

variable "tenant_trend_api_username" {
  description = "Tenant trend api username."
}

variable "tenant_trend_api_password" {
  description = "Tenant trend api password."
}

variable "tenant_trend_cloud_account_name" {
  description = "Tenant trend api cloud account name."
  default     = "prov-dev-2"
}

variable "custom_script_s3_bucket_name" {
  description = "name of the s3 bucket where the custom script resides"
  default     = ""
}

variable "custom_script_s3_bucket_key" {
  description = "path of the script - usaully will be key/name and script should be a txt file with shell scipt in it"
  default     = ""
}

variable "ebs_volumes" {
  description = "List of ebs volumes to be attached to the instance."
  default = []
}

variable "device_names" {
  default = ["/dev/xvdj",
  "/dev/xvdk",
  "/dev/xvdl",
  "/dev/xvdm",
  "/dev/xvdn",
  "/dev/xvdo",
  "/dev/xvdp"]
}

########
# Tags #
########
variable "tags" {
  description = "A map of tags to add to all resources."
  default     = {}
}

variable "instance_tags" {
  description = "A list of map of tags to all instances."
  default     = {}
}