module "slack_contact_point" {
  for_each                 = local.contact_point_webhook_map
  source                   = "../../grafana-resources/slack-contact-point"
  contact_point_name       = each.key
  webhook_url              = each.value
  disable_resolved_message = false
}

# Second contact point module for disabled resolved messages
module "slack_contact_point_not_send_resolved" {
  providers = {
    grafana = grafana
  }
  for_each                 = local.contact_point_logs_webhook_map
  source                   = "../../grafana-resources/slack-contact-point"
  contact_point_name       = each.key
  webhook_url              = each.value
  disable_resolved_message = true
}

resource "grafana_folder" "global_alerts" {
  title = format("alerts %s", var.environment_long)
}

resource "grafana_folder" "global_dashboards" {
  title = format("dashboards global")
}

# Drift fix https://github.com/grafana/terraform-provider-grafana/pull/1168
resource "grafana_notification_policy" "global" {
  contact_point = var.grafana_notification_policy_default_contact_point
  group_by      = var.grafana_notification_policy_default_group_by

  dynamic "policy" {
    for_each = var.grafana_notification_policies
    content {
      matcher {
        label = policy.value["matcher_label"]
        match = policy.value["matcher_operator"]
        value = policy.value["matcher_value"]
      }
      matcher {
        label = "resolved"
        match = policy.value["matcher_operator"]
        value = "true"
      }
      contact_point   = policy.value["contact_point"]
      group_by        = policy.value["group_by"]
      group_wait      = policy.value["group_wait"]
      group_interval  = policy.value["group_interval"]
      repeat_interval = policy.value["repeat_interval"]
    }
  }

  # Policies for alerts being sent to the contact point with disabled resolved messages
  dynamic "policy" {
    for_each = var.grafana_notification_policies
    content {
      matcher {
        label = policy.value["matcher_label"]
        match = policy.value["matcher_operator"]
        value = policy.value["matcher_value"]
      }
      matcher {
        label = "resolved"
        match = policy.value["matcher_operator"]
        value = "false"
      }
      contact_point   = policy.value["contact_point_logs"]
      group_by        = policy.value["group_by"]
      group_wait      = policy.value["group_wait"]
      group_interval  = policy.value["group_interval"]
      repeat_interval = policy.value["repeat_interval"]
      continue        = true
    }
  }
}

module "general_dashboard" {
  source                     = "../../grafana-resources/general-infra-dashboard"
  grafana_folder_uid         = grafana_folder.global_dashboards.id
  dashboard_title            = "Infrastructure Overview"
  dashboard_uid              = "global-infrastructure"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.ops.id
  environment_panels         = var.environment_panels
  metrics_vm_set = toset([
    for vm in concat(var.vms_cpu_alert, var.vms_memory_alert) :
    vm.name #vm["name"]
  ])
  subscription_id                      = var.subscription_id
  endpoint_availability_resource_group = var.monitoring_resource_group_name
  endpoint_availability_resource_name  = var.log_analytics_workspace_name
  application_insights_id              = azurerm_application_insights.endpoint_availability.id
}

module "office_blackbox_bashboard" {
  source                    = "../../grafana-resources/blackbox-exporter-dashboard"
  grafana_folder_uid        = grafana_folder.global_dashboards.id
  dashboard_title           = "Office Blackbox Exporter"
  dashboard_uid             = "office-blackbox-exporter"
  prometheus_datasource_uid = var.prometheus_datasource_uid
}
