<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.76.0 |
| <a name="provider_azurerm.<some-name-here>_hub"></a> [azurerm.<some-name-here>\_hub](#provider\_azurerm.<some-name-here>\_hub) | 3.76.0 |
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks_cluster"></a> [aks\_cluster](#module\_aks\_cluster) | ../../sub-modules/azure-resources/aks | n/a |
| <a name="module_argocd_outofsync_alert"></a> [argocd\_outofsync\_alert](#module\_argocd\_outofsync\_alert) | ../../sub-modules/grafana-resources/argocd-outofsync-alert | n/a |
| <a name="module_endpoint-availability-alert"></a> [endpoint-availability-alert](#module\_endpoint-availability-alert) | ../../sub-modules/grafana-resources/endpoint-availability-alert | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../../sub-modules/azure-resources/network-infrastructure | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ../../sub-modules/azure-resources/storageaccount | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.endpoint_availability](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_application_insights_web_test.endpoint_availability](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_web_test) | resource |
| [azurerm_firewall_nat_rule_collection.endpoint_availability](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_nat_rule_collection) | resource |
| [azurerm_ip_group.cluster-vnet-ip-group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ip_group) | resource |
| [azurerm_resource_group.monitoring](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet_route_table_association.route_table_assn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [grafana_folder.environment_alerts](https://registry.terraform.io/providers/hashicorp/grafana/latest/docs/resources/folder) | resource |
| [azurerm_log_analytics_workspace.ops](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_private_dns_zone.aks_private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.blob_storage_private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.privatelink_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.privatelink_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | account\_replication\_type | `string` | `"LRS"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | account\_tier | `string` | `"Standard"` | no |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | address space range to be assigned to the vnet | `list(string)` | <pre>[<br>  "10.86.0.0/16",<br>  "10.88.0.0/16"<br>]</pre> | no |
| <a name="input_application_insights_name"></a> [application\_insights\_name](#input\_application\_insights\_name) | Azure Application Insights name which will be created for endpoint availability monitoring | `string` | n/a | yes |
| <a name="input_argocd_url"></a> [argocd\_url](#input\_argocd\_url) | URL endpoint to argocd instance for this environment | `string` | n/a | yes |
| <a name="input_cluster_vnet_address"></a> [cluster\_vnet\_address](#input\_cluster\_vnet\_address) | address space for the cluster vnet | `string` | `"10.86.0.0/16"` | no |
| <a name="input_containers_list"></a> [containers\_list](#input\_containers\_list) | List of containers to create and their access levels. | `list(object({ name = string, access_type = string }))` | `[]` | no |
| <a name="input_create_network_resource_group"></a> [create\_network\_resource\_group](#input\_create\_network\_resource\_group) | Wheather to create a resource group or not | `bool` | `true` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Whether to create a resource group or not | `bool` | `true` | no |
| <a name="input_enable_advanced_threat_protection"></a> [enable\_advanced\_threat\_protection](#input\_enable\_advanced\_threat\_protection) | Boolean flag which controls if advanced threat protection is enabled. | `bool` | `false` | no |
| <a name="input_endpoint_test_nat_rule_priority"></a> [endpoint\_test\_nat\_rule\_priority](#input\_endpoint\_test\_nat\_rule\_priority) | Firewall rule priority for the NAT rule that forwards traffic to private endpoints for availability monitoring | `number` | n/a | yes |
| <a name="input_endpoint_test_source_addresses"></a> [endpoint\_test\_source\_addresses](#input\_endpoint\_test\_source\_addresses) | Azure-specific list of public IP addresses from which Azure Application Insights performs web availability tests | `list(string)` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | name of the environment | `string` | `"prod"` | no |
| <a name="input_env_long"></a> [env\_long](#input\_env\_long) | long name of the environment | `string` | `"production"` | no |
| <a name="input_env_to_hub_link_name"></a> [env\_to\_hub\_link\_name](#input\_env\_to\_hub\_link\_name) | description | `string` | `"prod-hub-link"` | no |
| <a name="input_environment_long"></a> [environment\_long](#input\_environment\_long) | Environment name, long format | `string` | n/a | yes |
| <a name="input_file_shares"></a> [file\_shares](#input\_file\_shares) | List of containers to create and their access levels. | `list(object({ name = string, quota = number }))` | `[]` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | Azure hub firewall name | `string` | n/a | yes |
| <a name="input_hub_network_id"></a> [hub\_network\_id](#input\_hub\_network\_id) | fully qualified path to the hub side vnet or the id of the hub vnet | `string` | `"/subscriptions/d7921938-d4d1-4b2d-a239-52b11e113b0b/resourceGroups/<some-name-here>-network-rg/providers/Microsoft.Network/virtualNetworks/<some-name-here>-network"` | no |
| <a name="input_hub_network_name"></a> [hub\_network\_name](#input\_hub\_network\_name) | name of the hub side vnet | `string` | `"<some-name-here>-network"` | no |
| <a name="input_hub_to_env_link_name"></a> [hub\_to\_env\_link\_name](#input\_hub\_to\_env\_link\_name) | description | `string` | `"hub-prod-link"` | no |
| <a name="input_kubernetes_subnet_name"></a> [kubernetes\_subnet\_name](#input\_kubernetes\_subnet\_name) | name of the subnet used for kubernets cluster | `string` | `"<some-name-here>-infra-prod-subnet01"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of kubernetes cluster | `string` | `"1.25.6"` | no |
| <a name="input_kubernetes_vnet_name"></a> [kubernetes\_vnet\_name](#input\_kubernetes\_vnet\_name) | vnet for creating the kubernets cluster | `string` | `"<some-name-here>-infra-prod-vnet"` | no |
| <a name="input_location"></a> [location](#input\_location) | name of the location | `string` | `"west europe"` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of Azure Log Analytics Workspace to be used as datasource | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group"></a> [log\_analytics\_workspace\_resource\_group](#input\_log\_analytics\_workspace\_resource\_group) | Name of Azure resource group in which <log\_analytics\_workspace\_name> resides | `string` | n/a | yes |
| <a name="input_monitoring_resource_group_name"></a> [monitoring\_resource\_group\_name](#input\_monitoring\_resource\_group\_name) | Name of Azure resource group for monitoring-related resources | `string` | n/a | yes |
| <a name="input_nat_rule_map"></a> [nat\_rule\_map](#input\_nat\_rule\_map) | Map keys hold private IP addresses while values hold public IP addresses associated with the hub firewall that should route traffic to the private IP address | `map(list(string))` | n/a | yes |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | name of the resource group | `string` | `"<some-name-here>-prod-rg"` | no |
| <a name="input_network_security_group_name"></a> [network\_security\_group\_name](#input\_network\_security\_group\_name) | name of the network security group | `string` | `"<some-name-here>-infra-prod-network-security-group"` | no |
| <a name="input_private_endpoints_severity_map"></a> [private\_endpoints\_severity\_map](#input\_private\_endpoints\_severity\_map) | Private endpoints to be monitored categorized by severity level.<br>  Key is severity level and holds list of private endpoints as value. | `map(list(string))` | n/a | yes |
| <a name="input_privatelink_subnet_name"></a> [privatelink\_subnet\_name](#input\_privatelink\_subnet\_name) | subnet name for the private link | `string` | `"<some-name-here>-infra-prod-subnet01"` | no |
| <a name="input_privatelinkblob"></a> [privatelinkblob](#input\_privatelinkblob) | n/a | `string` | `"privatelink.blob.core.windows.net"` | no |
| <a name="input_public_endpoints_severity_map"></a> [public\_endpoints\_severity\_map](#input\_public\_endpoints\_severity\_map) | Public endpoints to be monitored categorized by severity level.<br>  Key is severity level and holds list of public endpoints as value. | `map(list(string))` | n/a | yes |
| <a name="input_resource_group_name_hub"></a> [resource\_group\_name\_hub](#input\_resource\_group\_name\_hub) | default resource group name hub | `string` | `"<some-name-here>-network-rg"` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | prefix name to the module | `string` | `"<some-name-here>-infra"` | no |
| <a name="input_rule_argocd_outofsync"></a> [rule\_argocd\_outofsync](#input\_rule\_argocd\_outofsync) | ArgoCD OutOfSync Alert settings:<br>  Threshold is count of application in status 'OutOfSync' to trigger alert, non-inclusive.<br>  Datasource\_uid references prometheus instance.<br>  Severity references severity level. | <pre>object({<br>    evaluation_interval_seconds = optional(number, 60)<br>    evaluation_period           = optional(string, "60s")<br>    is_paused                   = optional(string, "true")<br>    additional_labels           = optional(map(string), {})<br>    threshold                   = number<br>    datasource_uid              = string<br>    severity                    = string<br>  })</pre> | n/a | yes |
| <a name="input_rule_endpoint_availability"></a> [rule\_endpoint\_availability](#input\_rule\_endpoint\_availability) | Settings for endpoint availability rule. | <pre>object({<br>    evaluation_interval_seconds = optional(number, 60)<br>    evaluation_period           = optional(string, "60s")<br>    is_paused                   = optional(string, "true")<br>    additional_labels           = optional(map(string), {})<br>  })</pre> | <pre>{<br>  "additional_labels": {},<br>  "evaluation_interval_seconds": 60,<br>  "evaluation_period": "60s",<br>  "is_paused": "true"<br>}</pre> | no |
| <a name="input_source_geo_locations"></a> [source\_geo\_locations](#input\_source\_geo\_locations) | List of Azure-specified acronyms representing different geo locations for Azure Application Insights | `list(string)` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the azure storage account | `string` | `"production"` | no |
| <a name="input_storageaccount_subnet_address"></a> [storageaccount\_subnet\_address](#input\_storageaccount\_subnet\_address) | Address prefixes of the available subnet in the network | `string` | `"10.86.2.0/24"` | no |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | subnet details | `map(string)` | <pre>{<br>  "<some-name-here>-infra-prod-subnet01": "10.86.0.0/24",<br>  "<some-name-here>-infra-prod-subnet02": "10.86.1.0/24"<br>}</pre> | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription ID of datasource | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | <pre>{<br>  "Created-by": "DevOps-admins-terraformed"<br>}</pre> | no |
| <a name="input_teamname"></a> [teamname](#input\_teamname) | Team name | `string` | `"devops"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | name of the virtual network | `string` | `"<some-name-here>-infra-prod-vnet"` | no |
| <a name="input_virtual_network_name_hub"></a> [virtual\_network\_name\_hub](#input\_virtual\_network\_name\_hub) | hub virtual network name | `string` | `"<some-name-here>-infra-prod-vnet"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->