variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID of datasource"
}

#####################################
# Network Module
#####################################

variable "kubernetes_version" {
  description = "Version of kubernetes cluster"
  type        = string
}

variable "environment_short" {
  type        = string
  description = "name of the environment"
}

variable "environment_long" {
  type        = string
  description = "long name of the environment"
}

variable "virtual_network_name" {
  type        = string
  description = "name of the virtual network"
}

variable "location" {
  type        = string
  description = "name of the location"
}

variable "address_space" {
  type        = list(string)
  description = "address space range to be assigned to the vnet"
}

variable "subnet_names" {
  type = list(object({
    name          = string
    address_space = string
  }))
  description = "subnet details"
}

variable "hub_to_env_link_name" {
  type        = string
  description = "description"
}

variable "env_to_hub_link_name" {
  type        = string
  description = "description"
}

###########################################
# Storage Accont Module
###########################################

variable "storage_account_name" {
  description = "The name of the azure storage account"
  type        = string
}

variable "containers_list" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, access_type = string }))
  default     = []
}

variable "file_shares" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, quota = number }))
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    created-by = "DevOps-Admins-Terraformed"
  }
}

variable "storageaccount_subnet_address" {
  description = "Address prefixes of the available subnet in the network"
  type        = string
}

variable "teamname" {
  description = "Team name"
  type        = string
}

variable "account_tier" {
  description = "account_tier"
  type        = string
  default     = "Standard"
}

variable "privatelinkblob_dnszone_id" {
  type = string
}

variable "account_replication_type" {
  description = "account_replication_type"
  type        = string
}

###########################################
# K8s Module
###########################################

variable "kubernetes_subnet_name" {
  type        = string
  description = "name of the subnet used for kubernets cluster"
}

variable "cluster_vnet_address" {
  type        = string
  description = "address space for the cluster vnet"
}

variable "analytics_workspace_daily_quota" {
  type        = number
  description = "Quota of GB daily consumption"
}

variable "privatelinkaks_dnszone_id" {
  type = string
}

###################################
# Kubernetes Configuration Vars
###################################

variable "resource_group_name" {
  type = string
}

variable "nginx_ingress_ip" {
  type        = string
  description = "IP address for the nginx controller"
}

variable "cluster_name" {
  type = string
}

variable "akv_name" {
  type = string
}

variable "user_group_all_azure_environmentname" {
  type = string
}

variable "cluster_issuer_gitlab_access_token_value" {
  type = string
}

variable "ifeswcom_dns_zone_manager_secret" {
  type = string
}

variable "ifeswcom_dns_zone_manager_appID" {
  type = string
}

variable "aerenacom_dns_zone_manager_secret" {
  type = string
}

variable "aerenacom_dns_zone_manager_appID" {
  type = string
}

variable "jaeger_gitlab_access_token_value" {
  type = string
}

variable "global_resources_gitlab_access_token_value" {
  type = string
}

variable "cert_manager_version" {
  type = string
}
variable "kubernetes_global_resources_version" {
  type = string
}
variable "ingress_version" {
  type = string
}

variable "ingress_package_registry_password" {
  type = string
}

###########################################
# Monitoring and Alerting
###########################################

variable "application_insights_name" {
  type        = string
  description = "Azure Application Insights name which will be created for endpoint availability monitoring"
}

variable "monitoring_resource_group_name" {
  type        = string
  description = "Name of Azure resource group for monitoring-related resources"
}

variable "grafana_env_dashboard_uid" {
  type        = string
  description = "value for environment related dashboard, i.e. not the global one"
}

variable "grafana_env_dashboard_title" {
  type        = string
  description = "Title for infrastructure dashboard"
}

variable "public_endpoints_severity_map" {
  type        = map(list(string))
  description = <<EOT
  Public endpoints to be monitored categorized by severity level.
  Key is severity level and holds list of public endpoints as value.
EOT
}

variable "private_endpoints_severity_map" {
  type        = map(list(string))
  description = <<EOT
  Private endpoints to be monitored categorized by severity level.
  Key is severity level and holds list of private endpoints as value.
EOT
}

variable "source_geo_locations" {
  type        = list(string)
  description = "List of Azure-specified acronyms representing different geo locations for Azure Application Insights"
}

variable "endpoint_test_nat_rule_priority" {
  type        = number
  description = "Firewall rule priority for the NAT rule that forwards traffic to private endpoints for availability monitoring"
}

variable "azure_appinsights_availability_ips" {
  type        = list(string)
  description = "Azure-specific list of public IP addresses from which Azure Application Insights performs web availability tests"
}

variable "firewall_name" {
  type        = string
  description = "Azure hub firewall name"
}

variable "nat_rule_map" {
  type        = map(list(string))
  description = "Map keys hold private IP addresses while values hold public IP addresses associated with the hub firewall that should route traffic to the private IP address"
}

variable "rule_endpoint_availability" {
  type = object({
    evaluation_interval_seconds = optional(number, 60)
    evaluation_period           = optional(string, "60s")
    is_paused                   = optional(string, "true")
    additional_labels           = optional(map(string), {})
  })
  description = "Settings for endpoint availability rule."
  nullable    = false
}

variable "rule_endpoint_response_time" {
  type = object({
    evaluation_interval_seconds = optional(number, 60)
    evaluation_period           = optional(string, "15m0s")
    is_paused                   = optional(string, "true")
    additional_labels           = optional(map(string), {})
  })
  description = "Settings for endpoint availability rule."
  nullable    = false
}

variable "rule_argocd_outofsync" {
  type = object({
    evaluation_interval_seconds = optional(number, 60)
    evaluation_period           = optional(string, "60s")
    is_paused                   = optional(string, "true")
    additional_labels           = optional(map(string), {})
    threshold                   = number
    datasource_uid              = string
    severity                    = string
  })
  description = <<EOT
  ArgoCD OutOfSync Alert settings:
  Threshold is count of application in status 'OutOfSync' to trigger alert, non-inclusive.
  Datasource_uid references prometheus instance.
  Severity references severity level.
EOT
}

variable "grafana_logs_alert" {
  type = map(object({
    alert_name                  = string
    query                       = string
    evaluation_interval_seconds = optional(number, 60)
    evaluation_period           = optional(string, "60s")
    is_paused                   = optional(string, "true")
  }))
  description = "Grafana logs alert configuration"
}

variable "argocd_url" {
  type        = string
  description = "URL endpoint to argocd instance for this environment"
}

variable "slack_contact_point_name" {
  type        = string
  description = "grafana contact endpoint parameter for notification in slack, e.g. `slack:aerena-ops-dev`"
}

variable "rule_cpu" {
  type = object({
    upper_threshold             = string
    lower_threshold             = string
    high_severity               = string
    low_severity                = string
    evaluation_interval_seconds = number
    evaluation_period           = string
    is_paused                   = bool
  })
}

variable "rule_memory" {
  type = object({
    upper_threshold             = string
    lower_threshold             = string
    high_severity               = string
    low_severity                = string
    evaluation_interval_seconds = number
    evaluation_period           = string
    is_paused                   = bool
  })
}

variable "rule_node_status" {
  type = object({
    threshold                   = string
    severity                    = string
    evaluation_interval_seconds = number
    evaluation_period           = string
    is_paused                   = bool
  })
}

variable "rule_cluster_health" {
  type = object({
    severity                    = string
    evaluation_interval_seconds = number
    evaluation_period           = string
    is_paused                   = bool
  })
}

variable "rule_pod_restart" {
  type = object({
    upper_threshold             = string
    lower_threshold             = string
    high_severity               = string
    low_severity                = string
    evaluation_interval_seconds = number
    evaluation_period           = string
    is_paused                   = bool
  })
}

variable "rule_storage_availability" {
  type = object({
    upper_threshold             = string
    lower_threshold             = string
    high_severity               = string
    low_severity                = string
    evaluation_interval_seconds = number
    evaluation_period           = string
    is_paused                   = bool
  })
}

###########################################
# Prometheus data Module
###########################################

variable "monitor_account_name" {
  type        = string
  description = "name of the prometheus monitor"
}

variable "prometheus_forwarder_name" {
  type        = string
  description = "name of the prometheus forwarder"
}

variable "streams" {
  type        = string
  description = "name of the prometheus streams"
}
