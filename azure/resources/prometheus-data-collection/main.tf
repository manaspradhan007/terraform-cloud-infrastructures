################################################################################
# Locals
################################################################################
terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [azurerm.hub]
    }
  }
}

################################################################################
# Data Collection endpoint and rule
################################################################################
resource "azurerm_monitor_data_collection_endpoint" "data_endpoint" {
  name                = "MSProm-${var.location}-${var.cluster_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "Linux"
}

resource "azurerm_monitor_data_collection_rule" "data_rule" {
  name                        = "MSProm-${var.location}-${var.cluster_name}"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.data_endpoint.id
  kind                        = "Linux"

  destinations {
    monitor_account {
      monitor_account_id = var.monitor_workspace_id
      name               = var.monitor_account_name
    }
  }

  data_flow {
    streams      = [var.streams]
    destinations = [var.monitor_account_name]
  }


  data_sources {
    prometheus_forwarder {
      streams = [var.streams]
      name    = var.prometheus_forwarder_name
    }
  }
}

################################################################################
# Rule association
################################################################################
resource "azurerm_monitor_data_collection_rule_association" "data_rule_association" {
  name                    = "MSProm-${var.location}-${var.cluster_name}"
  target_resource_id      = var.target_aks_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.data_rule.id
  description             = "Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster."
}