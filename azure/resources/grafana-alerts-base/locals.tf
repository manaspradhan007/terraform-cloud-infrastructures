locals {
  contact_point_webhook_map = { for policy in var.grafana_notification_policies :
    policy.contact_point => policy.webhook_url
  }
  contact_point_logs_webhook_map = { for policy in var.grafana_notification_policies :
    policy.contact_point_logs => policy.webhook_url
    # this contact points have disabled resolved messages
  }
  public_endpoints = flatten([
    for endpoint_list in values(var.public_endpoints_severity_map) :
    endpoint_list
  ])
}
