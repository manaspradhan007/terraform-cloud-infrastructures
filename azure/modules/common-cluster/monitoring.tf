module "env_dashboard" {
  source               = "../../sub-modules/grafana-resources/env-infra-dashboard"
  dashboard_title      = var.grafana_env_dashboard_title
  dashboard_uid        = var.grafana_env_dashboard_uid
  grafana_folder_uid   = grafana_folder.environment_dashboards.id
  aks_resource_id      = module.aks_cluster.cluster_id
  aks_name             = module.aks_cluster.name
  env_resource_group   = module.aks_cluster.resource_group
  storage_account_name = module.storage.storage_account_name
}

module "cpu-alert" {
  source                   = "../../sub-modules/grafana-resources/cpu-alert"
  aks                      = local.aks_monitoring_parameters
  environment_long         = var.environment_long
  subscription_id          = var.subscription_id
  grafana_dashboard_uid    = var.grafana_env_dashboard_uid
  grafana_panel_id         = module.env_dashboard.dashboard_panels["cluster_cpu_usage"]
  grafana_folder_uid       = grafana_folder.environment_alerts.uid
  rule_upper_threshold     = var.rule_cpu.upper_threshold
  rule_lower_threshold     = var.rule_cpu.lower_threshold
  rule_low_severity        = var.rule_cpu.low_severity
  rule_high_severity       = var.rule_cpu.high_severity
  rule_evaluation_interval = var.rule_cpu.evaluation_interval_seconds
  rule_evaluation_period   = var.rule_cpu.evaluation_period
  rule_is_paused           = var.rule_cpu.is_paused
}

module "memory-alert" {
  source                   = "../../sub-modules/grafana-resources/memory-alert"
  aks                      = local.aks_monitoring_parameters
  environment_long         = var.environment_long
  subscription_id          = var.subscription_id
  grafana_dashboard_uid    = var.grafana_env_dashboard_uid
  grafana_panel_id         = module.env_dashboard.dashboard_panels["cluster_memory_rss"]
  grafana_folder_uid       = grafana_folder.environment_alerts.uid
  rule_upper_threshold     = var.rule_memory.upper_threshold
  rule_lower_threshold     = var.rule_memory.lower_threshold
  rule_low_severity        = var.rule_memory.low_severity
  rule_high_severity       = var.rule_memory.high_severity
  rule_evaluation_interval = var.rule_memory.evaluation_interval_seconds
  rule_evaluation_period   = var.rule_memory.evaluation_period
  rule_is_paused           = var.rule_memory.is_paused
}

module "node-status-alert" {
  source                   = "../../sub-modules/grafana-resources/node-status-alert"
  aks                      = local.aks_monitoring_parameters
  environment_long         = var.environment_long
  subscription_id          = var.subscription_id
  grafana_dashboard_uid    = var.grafana_env_dashboard_uid
  grafana_panel_id         = module.env_dashboard.dashboard_panels["node_status"]
  grafana_folder_uid       = grafana_folder.environment_alerts.uid
  rule_threshold           = var.rule_node_status.threshold
  rule_severity            = var.rule_node_status.severity
  rule_evaluation_interval = var.rule_node_status.evaluation_interval_seconds
  rule_evaluation_period   = var.rule_node_status.evaluation_period
  rule_is_paused           = var.rule_node_status.is_paused
}

module "cluster-health-alert" {
  source                   = "../../sub-modules/grafana-resources/cluster-health-alert"
  aks                      = local.aks_monitoring_parameters
  environment_long         = var.environment_long
  subscription_id          = var.subscription_id
  grafana_dashboard_uid    = var.grafana_env_dashboard_uid
  grafana_panel_id         = module.env_dashboard.dashboard_panels["overall_cluster_health"]
  grafana_folder_uid       = grafana_folder.environment_alerts.uid
  rule_severity            = var.rule_cluster_health.severity
  rule_evaluation_interval = var.rule_cluster_health.evaluation_interval_seconds
  rule_evaluation_period   = var.rule_cluster_health.evaluation_period
  rule_is_paused           = var.rule_cluster_health.is_paused
}

module "pod-restart-alert" {
  source                   = "../../sub-modules/grafana-resources/pod-restart-alert"
  aks                      = local.aks_monitoring_parameters
  environment_long         = var.environment_long
  subscription_id          = var.subscription_id
  grafana_dashboard_uid    = var.grafana_env_dashboard_uid
  grafana_panel_id         = module.env_dashboard.dashboard_panels["pod_restart_count"]
  grafana_folder_uid       = grafana_folder.environment_alerts.uid
  rule_upper_threshold     = var.rule_pod_restart.upper_threshold
  rule_lower_threshold     = var.rule_pod_restart.lower_threshold
  rule_low_severity        = var.rule_pod_restart.low_severity
  rule_high_severity       = var.rule_pod_restart.high_severity
  rule_evaluation_interval = var.rule_pod_restart.evaluation_interval_seconds
  rule_evaluation_period   = var.rule_pod_restart.evaluation_period
  rule_is_paused           = var.rule_pod_restart.is_paused
}

module "storage-availability-alert" {
  source = "../../sub-modules/grafana-resources/storage-availability-alert"
  storage_account = {
    name           = module.storage.storage_account_name
    resource_group = var.resource_group_name
    location       = var.location
  }
  environment_long         = var.environment_long
  subscription_id          = var.subscription_id
  grafana_dashboard_uid    = var.grafana_env_dashboard_uid
  grafana_panel_id         = module.env_dashboard.dashboard_panels["storage_account_availability"]
  grafana_folder_uid       = grafana_folder.environment_alerts.uid
  rule_upper_threshold     = var.rule_storage_availability.upper_threshold
  rule_lower_threshold     = var.rule_storage_availability.lower_threshold
  rule_low_severity        = var.rule_storage_availability.low_severity
  rule_high_severity       = var.rule_storage_availability.high_severity
  rule_evaluation_interval = var.rule_storage_availability.evaluation_interval_seconds
  rule_evaluation_period   = var.rule_storage_availability.evaluation_period
  rule_is_paused           = var.rule_storage_availability.is_paused
}

module "endpoint-availability-alert" {
  source                      = "../../sub-modules/grafana-resources/endpoint-availability-alert"
  environment_long            = var.environment_long
  location                    = var.location
  subscription_id             = var.subscription_id
  grafana_folder_uid          = grafana_folder.environment_alerts.uid
  evaluation_interval_seconds = var.rule_endpoint_availability.evaluation_interval_seconds
  evaluation_period           = var.rule_endpoint_availability.evaluation_period
  is_paused                   = var.rule_endpoint_availability.is_paused
  additional_labels           = var.rule_endpoint_availability.additional_labels
  application_insights_id     = azurerm_application_insights.endpoint_availability.id
  severity_map                = merge(var.public_endpoints_severity_map, var.private_endpoints_severity_map)
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
  source                       = "../../sub-modules/grafana-resources/endpoint-response-time-alert"
  environment_long             = var.environment_long
  location                     = var.location
  subscription_id              = var.subscription_id
  grafana_dashboard_uid        = null
  grafana_panel_id             = null
  grafana_folder_uid           = grafana_folder.environment_alerts.uid
  evaluation_interval_seconds  = var.rule_endpoint_response_time.evaluation_interval_seconds
  evaluation_period            = var.rule_endpoint_response_time.evaluation_period
  is_paused                    = var.rule_endpoint_response_time.is_paused
  additional_labels            = var.rule_endpoint_response_time.additional_labels
  application_insights_id      = azurerm_application_insights.endpoint_availability.id
  severity_map                 = merge(var.public_endpoints_severity_map, var.private_endpoints_severity_map)
  threshold_in_ms              = each.value.threshold_in_ms
  location_comparison_operator = each.value.location_comparison_operator
  name_postfix                 = each.key
}

module "argocd_outofsync_alert" {
  source                      = "../../sub-modules/grafana-resources/argocd-outofsync-alert"
  environment_long            = var.environment_long
  grafana_folder_uid          = grafana_folder.environment_alerts.uid
  evaluation_interval_seconds = var.rule_argocd_outofsync.evaluation_interval_seconds
  evaluation_period           = var.rule_argocd_outofsync.evaluation_period
  is_paused                   = var.rule_argocd_outofsync.is_paused
  threshold                   = var.rule_argocd_outofsync.threshold
  datasource_uid              = var.rule_argocd_outofsync.datasource_uid
  argocd_url                  = var.argocd_url
  severity                    = var.rule_argocd_outofsync.severity
  additional_labels           = var.rule_argocd_outofsync.additional_labels
}

module "logs-alert" {
  for_each                    = var.grafana_logs_alert
  source                      = "../../sub-modules/grafana-resources/logs-alert"
  alert_name                  = format("%s-%s", var.environment_long, each.value.alert_name)
  environment_long            = var.environment_long
  query                       = each.value.query
  subscription_id             = var.subscription_id
  grafana_folder_uid          = grafana_folder.environment_alerts.uid
  evaluation_interval_seconds = each.value.evaluation_interval_seconds
  evaluation_period           = each.value.evaluation_period
  is_paused                   = each.value.is_paused
  log_workspace_id            = module.aks_cluster.log_analytics_workspace_id
}

resource "grafana_folder" "environment_alerts" {
  title = format("alerts %s", var.environment_long)
}

resource "grafana_folder" "environment_dashboards" {
  title = format("dashboards %s", var.environment_long)
}

resource "azurerm_resource_group" "monitoring" {
  name     = var.monitoring_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_firewall_nat_rule_collection" "endpoint_availability" {
  resource_group_name = local.resource_group_name_hub
  azure_firewall_name = var.firewall_name
  name                = format("endpoint-ping-test-%s", var.environment_long)
  action              = "Dnat"
  priority            = var.endpoint_test_nat_rule_priority

  dynamic "rule" {
    for_each = var.nat_rule_map
    content {
      name                  = format("allow http to %s", rule.key)
      protocols             = ["TCP"]
      destination_ports     = ["80"]
      source_addresses      = var.azure_appinsights_availability_ips
      destination_addresses = rule.value
      translated_address    = rule.key
      translated_port       = 80
    }
  }

  dynamic "rule" {
    for_each = var.nat_rule_map
    content {
      name                  = format("allow https to %s", rule.key)
      protocols             = ["TCP"]
      destination_ports     = ["443"]
      source_addresses      = var.azure_appinsights_availability_ips
      destination_addresses = rule.value
      translated_address    = rule.key
      translated_port       = 443
    }
  }
}

resource "azurerm_application_insights" "endpoint_availability" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = azurerm_resource_group.monitoring.name
  workspace_id        = module.aks_cluster.log_analytics_workspace_id
  application_type    = "web"
  tags                = var.tags
}

resource "azurerm_application_insights_web_test" "endpoint_availability" {
  for_each                = toset(concat(local.public_endpoints, local.private_endpoints))
  name                    = replace(replace(each.value, "://", "   "), "/", " ")
  location                = var.location
  resource_group_name     = azurerm_resource_group.monitoring.name
  application_insights_id = azurerm_application_insights.endpoint_availability.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 60
  enabled                 = true
  geo_locations           = var.source_geo_locations
  configuration           = templatefile("${path.module}/files/WebTest.xml", { endpoint = each.value })
  tags                    = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "kubernetes_config_map" "prometheus" {
  metadata {
    name      = "ama-metrics-prometheus-config"
    namespace = "kube-system"
  }
  data = {
    prometheus-config = "${file("${path.module}/files/prometheus-config.yaml")}"
  }
}

resource "kubernetes_config_map" "prometheus-node" {
  metadata {
    name      = "ama-metrics-prometheus-config-node"
    namespace = "kube-system"
  }
  data = {
    prometheus-config = "${file("${path.module}/files/prometheus-config.yaml")}"
  }
}
