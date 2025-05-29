variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "subnet_name" {
  type        = string
  description = "Subnet to create"
  default     = "KubernetesResources"
}

variable "function_app_version" {
  description = "Version of the function app runtime to use."
  type        = number
  default     = 4
}


variable "function_app_application_settings" {
  description = "Function App application settings."
  type        = map(string)
}

variable "identity_type" {
  description = "Add an Identity (MSI) to the function app. Possible values are SystemAssigned or UserAssigned."
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "User Assigned Identities IDs to add to Function App. Mandatory if type is UserAssigned."
  type        = list(string)
  default     = null
}

variable "authorized_ips" {
  description = "IPs restriction for Function in CIDR format. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#ip_restriction"
  type        = list(string)
  default     = []
}

variable "authorized_subnet_ids" {
  description = "Subnets restriction for Function App. See documentation https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "ip_restriction_headers" {
  description = "IPs restriction headers for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#headers"
  type        = map(list(string))
  default     = null
}

variable "authorized_service_tags" {
  description = "Service Tags restriction for Function App. See documentation https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "function_app_vnet_integration_subnet_id" {
  description = "ID of the subnet to associate with the Function App (Virtual Network integration)."
  type        = string
  default     = null
}

variable "site_config" {
  description = "Site config for Function App. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block."
  type        = any
  default     = {}
}

variable "sticky_settings" {
  description = "Lists of connection strings and app settings to prevent from swapping between slots."
  type = object({
    app_setting_names       = optional(list(string))
    connection_string_names = optional(list(string))
  })
  default = null
}

variable "https_only" {
  description = "Whether HTTPS traffic only is enabled."
  type        = bool
  default     = true
}

variable "builtin_logging_enabled" {
  description = "Whether built-in logging is enabled."
  type        = bool
  default     = true
}

variable "client_certificate_enabled" {
  description = "Whether the Function App uses client certificates."
  type        = bool
  default     = null
}

variable "client_certificate_mode" {
  description = "The mode of the Function App's client certificates requirement for incoming requests. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`."
  type        = string
  default     = null
}

variable "application_zip_package_path" {
  description = "Local or remote path of a zip package to deploy on the Function App."
  type        = string
  default     = null
}

variable "staging_slot_enabled" {
  description = "Create a staging slot alongside the Function App for blue/green deployment purposes."
  type        = bool
  default     = false
}

variable "staging_slot_custom_application_settings" {
  description = "Override staging slot with custom application settings."
  type        = map(string)
  default     = null
}

# SCM parameters

variable "scm_authorized_ips" {
  description = "SCM IPs restriction for Function App. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "scm_authorized_subnet_ids" {
  description = "SCM subnets restriction for Function App. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "scm_ip_restriction_headers" {
  description = "IPs restriction headers for Function App. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction"
  type        = map(list(string))
  default     = null
}

variable "scm_authorized_service_tags" {
  description = "SCM Service Tags restriction for Function App. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "storage_uses_managed_identity" {
  description = "Whether the Function App use Managed Identity to access the Storage Account. **Caution** This disable the storage keys on the Storage Account if created within the module."
  type        = bool
  default     = false
}

variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
}

variable "location" {
  type        = string
  description = "The azure location used for azure"
  default     = "West Europe"
}

variable "project" {
  type        = string
  description = "Three letter project key"
}

variable "function_app" {
  type        = string
  description = "Function App"
}

variable "env" {
  description = "environment such as dev, int, stage, demo"
  type        = string
}

variable "resource_group_name_hub" {
  description = "Default network resource group"

}

variable "network_name_hub" {
  type = string
}

variable "sku_name" {
  type        = string
  description = "B1, B2, B3, D1, F1, FREE, I1, I1v2, I2, I2v2, I3, I3v2, I4v2, I5v2, I6v2, P0V3, P1MV3, P1V2, P1V3, P2MV3, P2V2, P2V3, P3MV3, P3V2, P3V3, P4MV3, P5MV3, S1, S2, S3, SHARED, WS1, WS2, WS3, Y1" #https://learn.microsoft.com/en-us/cli/azure/appservice/plan?view=azure-cli-latest
  default     = "Y1"                                                                                                                                                                                           # dynamic function consumption plan
}

variable "os_type" {
  description = "os_type selects if Windows or Linux"
  type        = string
  default     = "Linux"
}

variable "storage_account_name" {
  description = "The name of the azure storage account"
  default     = ""
  type        = string
}

variable "privatelink" {
  description = "Default for existing privatelink DNS zone"
  default     = "privatelink.blob.core.windows.net"
}

variable "functionapp_subnet_address" {
  type        = string
  description = "Subnet address get it from DevOps"
}


variable "devops-storage-private-endpoint-name" {
  type    = string
  default = "funcappstorageblob"
}

variable "function_app_language" {
  type = string
}

variable "analytics_workspace_sku" {
  type    = string
  default = "PerGB2018"
}

variable "application_insights_id" {
  description = "ID of the existing Application Insights to use instead of deploying a new one."
  type        = string
  default     = null
}

variable "application_insights_enabled" {
  description = "Whether Application Insights should be deployed."
  type        = bool
  default     = true
}

variable "application_insights_type" {
  description = "Application Insights type if need to be generated. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights#application_type "
  type        = string
  default     = "web"
}

variable "application_insights_retention" {
  description = "Retention period (in days) for logs."
  type        = number
  default     = 90
}

variable "application_insights_internet_ingestion_enabled" {
  description = "Whether ingestion support from Application Insights component over the Public Internet is enabled."
  type        = bool
  default     = true
}

variable "application_insights_internet_query_enabled" {
  description = "Whether querying support from Application Insights component over the Public Internet is enabled."
  type        = bool
  default     = true
}

variable "application_insights_local_authentication_disabled" {
  description = "Whether Non-Azure AD based authentication is disabled."
  type        = bool
  default     = false
}

variable "per_site_scaling_enabled" {
  description = "Should Per Site Scaling be enabled."
  type        = bool
  default     = false
}

variable "storage_account_network_bypass" {
  description = "Whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of `Logging`, `Metrics`, `AzureServices`, or `None`."
  type        = list(string)
  default     = ["Logging", "Metrics", "AzureServices"]
}