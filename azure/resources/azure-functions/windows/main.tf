################################################################################
# resource group
################################################################################

resource "azurerm_resource_group" "resource_group" {
  provider = azurerm.primary
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags

  lifecycle {
    ignore_changes = [
      name
    ]
  }
}


################################################################################
# subnet
################################################################################

resource "azurerm_subnet" "subnet" {
  provider             = azurerm.primary
  name                 = format ("funcappwindows-%s-%s", var.project,var.env)
  resource_group_name  = var.resource_group_name_hub
  virtual_network_name = var.network_name_hub
  address_prefixes     = [var.functionapp_subnet_address]
  service_endpoints    = [
    "Microsoft.Storage",
    "Microsoft.Web"
  ]
delegation {
  name = "azure-function-delegation"
service_delegation {
    name    = "Microsoft.Web/serverFarms"
    actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

################################################################################
# log analytics workspace
################################################################################

resource "azurerm_log_analytics_workspace" "analytics_workspace" {
  provider            = azurerm.primary
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  name                = format ("%s-%s-logs", var.project,var.function_app)
  tags                = var.tags
  daily_quota_gb      = -1
  retention_in_days   = 30
  sku                 = var.analytics_workspace_sku
}

################################################################################
# application insights
################################################################################

resource "azurerm_application_insights" "app_insights" {
  provider                   = azurerm.primary  
  name                       = format ("%s-%s", var.project,var.function_app)
  location                   = azurerm_resource_group.resource_group.location
  resource_group_name        = azurerm_resource_group.resource_group.name
  workspace_id               = azurerm_log_analytics_workspace.analytics_workspace.id
  application_type           = var.application_insights_type
  retention_in_days          = var.application_insights_retention
  internet_ingestion_enabled = var.application_insights_internet_ingestion_enabled
  internet_query_enabled     = var.application_insights_internet_query_enabled
  local_authentication_disabled       = var.application_insights_local_authentication_disabled
  tags                       = var.tags
}


################################################################################
# service plan
################################################################################

resource "azurerm_service_plan" "plan" {
  provider            = azurerm.primary
  name                = format ("%s-%s",var.function_app, var.project)
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  os_type             = var.os_type
  sku_name            = "B1"
  per_site_scaling_enabled   = var.per_site_scaling_enabled
  tags                = var.tags
}


################################################################################
# storage account
################################################################################

resource "random_string" "unique" {
  length  = 3
  special = false
  upper   = false
}

resource "azurerm_storage_account" "function_app_storage_account" {
  provider                 = azurerm.primary
  name                      = substr(format("<name>%s%s%s", lower(replace(var.storage_account_name, "/[[:^alnum:]]/", "")), random_string.unique.result, var.env), 0, 24)
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_account_network_rules" "storage_network_rules" {
  provider                   = azurerm.primary
  storage_account_id         = azurerm_storage_account.function_app_storage_account.id
  default_action             = "Allow"
  ip_rules                   = []
  virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
  bypass                     = var.storage_account_network_bypass
}


################################################################################
# function app
################################################################################

resource "azurerm_windows_function_app" "windows_function" {
  provider                   = azurerm.primary

  name                       = format ("%s-%s", var.project,var.function_app)

  service_plan_id            = azurerm_service_plan.plan.id
  location                   = azurerm_resource_group.resource_group.location
  resource_group_name        = azurerm_resource_group.resource_group.name
  storage_account_name       = azurerm_storage_account.function_app_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_app_storage_account.primary_access_key
  functions_extension_version = "~${var.function_app_version}"

  virtual_network_subnet_id  = azurerm_subnet.subnet.id
  https_only                 = var.https_only
  builtin_logging_enabled    = var.builtin_logging_enabled


  app_settings = merge(
    var.function_app_application_settings,
  )
  
  site_config {
    application_insights_connection_string = azurerm_application_insights.app_insights.connection_string
    application_insights_key               = azurerm_application_insights.app_insights.instrumentation_key
    ftps_state                             = "AllAllowed"
    vnet_route_all_enabled                 = true
  }
  

  lifecycle {
    ignore_changes = all 
  }

  identity {
    type = "SystemAssigned"
  }
  
  tags = {
    "created-by"                                     = var.tags["created-by"]
    "hidden-link: /app-insights-instrumentation-key" = azurerm_application_insights.app_insights.instrumentation_key
    "hidden-link: /app-insights-resource-id"         = azurerm_application_insights.app_insights.id
  } 
}

