#############
# Providers #
#############
region     = "<insert region here>"
access_key = "<insert access_key here>"
secret_key = "<insert secret_key here>"
token      = "<insert token here>"

master_region     = "<insert master region here>"
master_access_key = "<insert master access_key here>"
master_secret_key = "<insert master secret_key here>"
master_token      = "<insert master token here>" 

############
# Instance #
############
default_linux_server_example_resource_name_prefix            = "D1IPV1-DEMO"
default_linux_server_example_subnet_id                       = "subnet-0b9fd14de1436740f" #private subnet
default_linux_server_example_ami_id                          = "ami-0ae185e348042e7a1" 
 

############
# Userdata #
############
default_linux_server_example_host_name                       = "d1ipv101demo"
default_linux_server_example_tenant_code                     = "IPV1"
default_linux_server_example_tenant_environment              = "DEV"
client_code                                                  = "IPV1"
default_linux_server_example_tenant_environment_sequence     = "1"           
default_windows_server_example_custom_script_s3_bucket_name  = ""
default_windows_server_example_custom_script_s3_bucket_key   = ""
default_linux_server_example_key_name                        = "dev"
default_linux_server_example_instance_profile_name           = ""##
default_linux_server_example_install_rapid7                  = false
default_linux_server_example_install_sentinelone	     	 = false 
default_linux_server_example_ebs_volumes                     = []

# This variable is a list of map for all ebs volumes that needs to be attached.It has volume_size/sanpshot_id as a required parameter,rest all values if not set will be defaulted. 
#  For example- 
#     [{"volume_size"    = 4,  "disk_group"= "PGV1_FLASH" },
#	{ "volume_size"    = 4, "disk_group"= "PGV1_FLASH"   }]
default_linux_server_example_device_names                    = []

 

#############
# ELK hosts #
#############
default_linux_server_example_kafka_elb_endpoint = "kelk-dev-kafka.lowerenv.com"

 

########
# Tags #
########
default_linux_server_example_tags                            = { "TenantCode" = "D1IPV1", "UserName" = "inspecpipeline" }
default_linux_server_example_instance_tags                   = { "0050:InfraMgmt" = "", "0600:Auditable (PCI)" = "N" }


