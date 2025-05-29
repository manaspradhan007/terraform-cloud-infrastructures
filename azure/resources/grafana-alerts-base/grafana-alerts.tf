module "endpoint-availability-alert" {
  source                      = "../../grafana-resources/endpoint-availability-alert"
  environment_long            = var.environment_long
  location                    = var.location
  subscription_id             = var.subscription_id
  grafana_dashboard_uid       = module.general_dashboard.dashboard_uid
  grafana_panel_id            = module.general_dashboard.dashboard_panel_ids["endpoint_availability"]
  grafana_folder_uid          = grafana_folder.global_alerts.uid
  evaluation_interval_seconds = var.rule_endpoint_availability.evaluation_interval_seconds
  evaluation_period           = var.rule_endpoint_availability.evaluation_period
  is_paused                   = var.rule_endpoint_availability.is_paused
  additional_labels           = var.rule_endpoint_availability.additional_labels
  application_insights_id     = azurerm_application_insights.endpoint_availability.id
  severity_map                = var.public_endpoints_severity_map
}

module "endpoint-response-time-alert" {
  for_each = {
    same-region = {
      location_comparison_operator = "=="
      threshold_in_ms              = 500
    }
    different-region = {
      location_comparison_operator = "!="
      threshold_in_ms              = 7000
    }
  }
  source                       = "../../grafana-resources/endpoint-response-time-alert"
  environment_long             = var.environment_long
  location                     = var.location
  subscription_id              = var.subscription_id
  grafana_dashboard_uid        = null
  grafana_panel_id             = null
  grafana_folder_uid           = grafana_folder.global_alerts.uid
  evaluation_interval_seconds  = var.rule_endpoint_response_time.evaluation_interval_seconds
  evaluation_period            = var.rule_endpoint_response_time.evaluation_period
  is_paused                    = var.rule_endpoint_response_time.is_paused
  additional_labels            = var.rule_endpoint_response_time.additional_labels
  application_insights_id      = azurerm_application_insights.endpoint_availability.id
  severity_map                 = var.public_endpoints_severity_map
  threshold_in_ms              = each.value.threshold_in_ms
  location_comparison_operator = each.value.location_comparison_operator
  name_postfix                 = each.key
}

module "vm_heartbeat_alert" {
  source                      = "../../grafana-resources/vm-heartbeat-alert"
  environment_long            = var.environment_long
  subscription_id             = var.subscription_id
  grafana_dashboard_uid       = module.general_dashboard.dashboard_uid
  grafana_panel_id            = module.general_dashboard.dashboard_panel_ids["heartbeats"]
  grafana_folder_uid          = grafana_folder.global_alerts.uid
  log_analytics_workspace_id  = var.vm_heartbeat_alert.log_analytics_workspace_id
  evaluation_interval_seconds = var.vm_heartbeat_alert.evaluation_interval_seconds
  evaluation_period           = var.vm_heartbeat_alert.evaluation_period
  is_paused                   = var.vm_heartbeat_alert.is_paused
  additional_labels           = var.vm_heartbeat_alert.additional_alert_labels
  severity_map                = var.vm_heartbeat_alert.severity_map
  severity_remainder          = var.vm_heartbeat_alert.severity_remainder
  heartbeat_window_minutes    = var.vm_heartbeat_alert.heartbeat_window_minutes
}

module "vm_cpu_alert" {
  for_each = {
    for index, vm in var.vms_cpu_alert :
    index => vm
  }
  source                      = "../../grafana-resources/vm-metric-alert"
  environment_long            = var.environment_long
  location                    = var.location
  subscription_id             = var.subscription_id
  grafana_dashboard_uid       = module.general_dashboard.dashboard_uid
  grafana_panel_id            = module.general_dashboard.dashboard_panel_ids[each.value.name]["cpu"]
  grafana_folder_uid          = grafana_folder.global_alerts.uid
  thresholds                  = each.value.thresholds
  evaluation_interval_seconds = each.value.evaluation_interval_seconds
  evaluation_period           = each.value.evaluation_period
  is_paused                   = each.value.is_paused
  additional_alert_labels     = each.value.additional_alert_labels
  vm_name                     = each.value.name
  log_analytics_workspace_id  = data.azurerm_log_analytics_workspace.ops.id
  metric_name                 = "UtilizationPercentage"
  annotation_summary          = "Mean CPU usage is {{ $values.B.Value }} for the last 5 minutes!"
  threshold_operator          = "gt"
}

module "vm_memory_alert" {
  for_each = {
    for index, vm in var.vms_memory_alert :
    index => vm
  }
  source                      = "../../grafana-resources/vm-metric-alert"
  environment_long            = var.environment_long
  location                    = var.location
  subscription_id             = var.subscription_id
  grafana_dashboard_uid       = module.general_dashboard.dashboard_uid
  grafana_panel_id            = module.general_dashboard.dashboard_panel_ids[each.value.name]["memory"]
  grafana_folder_uid          = grafana_folder.global_alerts.uid
  thresholds                  = each.value.thresholds
  evaluation_interval_seconds = each.value.evaluation_interval_seconds
  evaluation_period           = each.value.evaluation_period
  is_paused                   = each.value.is_paused
  additional_alert_labels     = each.value.additional_alert_labels
  vm_name                     = each.value.name
  log_analytics_workspace_id  = data.azurerm_log_analytics_workspace.ops.id
  metric_name                 = "AvailableMB"
  annotation_summary          = "Mean available memory is {{ $values.B.Value }} for the last 5 minutes!"
  threshold_operator          = "lt"
}

module "office_blackbox_prometheus_alert" {
  source                = "../../grafana-resources/prometheus-alert"
  environment_long      = var.environment_long
  grafana_dashboard_uid = module.office_blackbox_bashboard.dashboard_uid
  panel_id              = module.office_blackbox_bashboard.panel_id
  grafana_folder_uid    = grafana_folder.global_alerts.uid
  threshold             = 1
  threshold_operator    = "lt"
  is_paused             = false
  alert_name            = "office-blackbox-exporter-availability"
  additional_annotations = {
    "Summary" : "The endpoint {{ $labels.instance }} is not available from office!"
    "Link" : "{{ $labels.instance }}"
  }
  prometheus_datasource_uid = var.prometheus_datasource_uid
  query_expression          = "probe_success{job=\"blackbox\"}"
  severity                  = "critical"
}
