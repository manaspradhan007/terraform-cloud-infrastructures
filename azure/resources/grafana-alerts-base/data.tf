data "azurerm_log_analytics_workspace" "ops" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group
}
