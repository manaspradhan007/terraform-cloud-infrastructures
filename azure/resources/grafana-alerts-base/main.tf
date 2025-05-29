
resource "azurerm_application_insights" "endpoint_availability" {
  name                = var.application_insights_name != null ? var.application_insights_name : format("endpoint-ping-%s", var.environment_long)
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = data.azurerm_log_analytics_workspace.ops.id
  application_type    = "web"
  tags                = var.tags
}

resource "azurerm_application_insights_web_test" "endpoint_availability" {
  for_each                = toset(local.public_endpoints)
  name                    = replace(replace(each.value, "://", "   "), "/", " ")
  location                = var.location
  resource_group_name     = var.resource_group_name
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
