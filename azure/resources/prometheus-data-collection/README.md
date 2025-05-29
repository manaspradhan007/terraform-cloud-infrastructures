<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_data_collection_endpoint.dce](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_endpoint) | resource |
| [azurerm_monitor_data_collection_rule.dcr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) | resource |
| [azurerm_monitor_data_collection_rule_association.dcra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The AKS cluster name | `string` | n/a | yes |
| <a name="input_env_long"></a> [env\_long](#input\_env\_long) | full or long name of the environment e.g develop, integration, staging | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Resource group location | `string` | n/a | yes |
| <a name="input_monitor_account_name"></a> [monitor\_account\_name](#input\_monitor\_account\_name) | Name of the Monitoring account | `string` | n/a | yes |
| <a name="input_monitor_workspace_id"></a> [monitor\_workspace\_id](#input\_monitor\_workspace\_id) | The Azure Monitor Workspace id | `string` | n/a | yes |
| <a name="input_prometheus_forwarder_name"></a> [prometheus\_forwarder\_name](#input\_prometheus\_forwarder\_name) | Data source forwarder name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name | `string` | n/a | yes |
| <a name="input_streams"></a> [streams](#input\_streams) | Data source streams | `string` | n/a | yes |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | Target AKS cluster id | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->