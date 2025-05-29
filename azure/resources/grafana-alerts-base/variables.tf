variable "resource_group_name" {
  type        = string
  description = "name of the resource group"
}

variable "environment_long" {
  type        = string
  description = "Environment name, long format"
}

variable "subscription_id" {
  type = string
}

variable "location" {
  type        = string
  description = "name of the location"
  default     = "west europe"
}

variable "tags" {
  type    = map(string)
  default = { Created_by = "DevOps-Admins-Terragrunted" }
}

###########################################
# Monitoring and Alerting
###########################################
variable "application_insights_name" {
  type        = string
  description = "Azure Application Insights name which will be created for endpoint availability monitoring"
  default     = null
}

variable "monitoring_resource_group_name" {
  type        = string
  description = "Name of Azure resource group for monitoring-related resources"
  default     = null
}

variable "environment_panels" {
  type = list(object({
    aks_name           = string
    aks_resource_id    = string
    env_resource_group = string
    subscription_id    = string
    location           = string
    environment_name   = string
  }))
  description = "Parameters for environment-specific panels for the general infrastructure dashboard"
}

variable "public_endpoints_severity_map" {
  type        = map(list(string))
  description = <<EOT
  Public endpoints to be monitored categorized by severity level.
  Key is severity level and holds list of public endpoints as value.
EOT
}

variable "rule_endpoint_availability" {
  type = object({
    evaluation_interval_seconds = optional(number, 60)
    evaluation_period           = optional(string, "60s")
    is_paused                   = optional(string, "true")
    additional_labels           = optional(map(string), {})
  })
  description = "Settings for endpoint availability rule."
  nullable = false
}

variable "rule_endpoint_response_time" {
  type = object({
    evaluation_interval_seconds = optional(number, 60)
    evaluation_period           = optional(string, "15m0s")
    is_paused                   = optional(string, "true")
    additional_labels           = optional(map(string), {})
  })
  description = "Settings for endpoint availability rule."
  nullable = false
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Azure Log Analytics Workspace to be used as datasource"
}

variable "log_analytics_workspace_resource_group" {
  type        = string
  description = "Name of Azure resource group in which <log_analytics_workspace_name> resides"
}

variable "source_geo_locations" {
  type        = list(string)
  description = "List of Azure-specified acronyms representing different geo locations for Azure Application Insights"
}

variable "grafana_notification_policies" {
  type = list(object({
    matcher_label      = string
    matcher_operator   = optional(string, "=")
    matcher_value      = string
    contact_point      = string
    contact_point_logs = string
    group_by           = optional(list(string), ["..."])
    group_wait         = optional(string, "0s")
    group_interval     = optional(string, "5m")
    repeat_interval    = optional(string, "1h")
    webhook_url        = string
    child_policies = optional(list(object({
      matcher_label      = string
      matcher_operator   = string
      matcher_value      = string
      contact_point      = string
      contact_point_logs = string
      group_by           = list(string)
      group_wait         = string
      group_interval     = string
      repeat_interval    = string
    })), [])
  }))
  description = <<EOT
    Notification policies as list of objects.
    Object has attribute assigned that are necessary for deployment of grafana
    notification policies.
EOT
}

variable "grafana_notification_policy_default_contact_point" {
  type        = string
  description = "Default contact point for grafana notifications"
  default     = "slack:aerena-ops-global"
}

variable "grafana_notification_policy_default_group_by" {
  type        = list(string)
  description = "Default policy sgroup in which grafana policies will be created"
  default     = ["..."]
}

variable "vm_heartbeat_alert" {
  type = object({
    evaluation_interval_seconds = optional(number, 60)
    evaluation_period           = optional(string, "60s")
    is_paused                   = optional(string, "true")
    additional_alert_labels     = optional(map(string), {})
    severity_map                = map(list(string))
    severity_remainder          = string
    heartbeat_window_minutes    = optional(number, 5)
    log_analytics_workspace_id  = string
  })
  description = <<EOT
    Heartbeat alert settings for all virtual machines.
    'heartbeat_window_minutes' refers to the threshold that the alert will trigger on when missing heartbeats.
    'log_analytics_workspace_id' refers to data source for evaluating vm heartbeats.
    'severity_map' is a map of lists whereas the key is a severity level (string)
    and the list items are VM names.
    'severity_remainder' is the severity level which is applied for all unmentioned
    VMs in 'severity_map'
    Default alert labels are 'env' and 'severity'.
    Additional labels can be set by 'additional_alert_labels' whereas values must be strings.
EOT
}

variable "vms_cpu_alert" {
  type = list(object({
    name                        = string
    thresholds                  = optional(map(string), { "80.1" = "info", "95.1" = "warning" })
    evaluation_interval_seconds = optional(number, 60)
    evaluation_period           = optional(string, "5m")
    is_paused                   = optional(string, "true")
    additional_alert_labels     = optional(map(string), {})
  }))
  description = <<EOT
    CPU alert settings per virtual machine.
    'Thresholds' is a map with number keys and string values and maximum length 2.
    Use floating point numbers unlike "x.0", terraform tonumber() removes "0" floating points.
    Also, terraform does not accept optional(map(number)) with floating points.
    Default alert labels are 'env' and 'severity'.
    Additional labels can be set by 'additional_alert_labels' whereas values must be strings.
EOT
}

variable "vms_memory_alert" {
  type = list(object({
    name                        = string
    thresholds                  = optional(map(string), { "2000.1" = "info", "1000.1" = "warning" })
    evaluation_interval_seconds = optional(number, 60)
    evaluation_period           = optional(string, "5m")
    is_paused                   = optional(string, "true")
    additional_alert_labels     = optional(map(string), {})
  }))
  description = <<EOT
    Memory alert settings per virtual machine.
    'Thresholds' is a map with number keys and string values and maximum length 2.
    Use floating point numbers unlike "x.0", terraform tonumber() removes "0" floating points.
    Also, terraform does not accept optional(map(number)) with floating points.
    Default alert labels are 'env' and 'severity'.
    Additional labels can be set by 'additional_alert_labels' whereas values must be strings.
EOT
}

variable "prometheus_datasource_uid" {
  type = string
}
