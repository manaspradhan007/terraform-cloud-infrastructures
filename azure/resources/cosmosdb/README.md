<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_privatelink"></a> [privatelink](#module\_privatelink) | ../privatelink | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key_metadata_writes_enabled"></a> [access\_key\_metadata\_writes\_enabled](#input\_access\_key\_metadata\_writes\_enabled) | Enable creation of DB and Collections from Client | `bool` | `true` | no |
| <a name="input_additional_capabilities"></a> [additional\_capabilities](#input\_additional\_capabilities) | List of additional capabilities for Cosmos DB API. - possible options are DisableRateLimitingResponses, EnableAggregationPipeline, EnableServerless, mongoEnableDocLevelTTL, MongoDBv3.4, AllowSelfServeUpgradeToMongo36 | `list(string)` | <pre>[<br>  "DisableRateLimitingResponses",<br>  "EnableServerless"<br>]</pre> | no |
| <a name="input_auto_failover"></a> [auto\_failover](#input\_auto\_failover) | Enable automatic fail over for this Cosmos DB account - can be either true or false | `bool` | `false` | no |
| <a name="input_azure_portal_access"></a> [azure\_portal\_access](#input\_azure\_portal\_access) | List of ip address to enable the Allow access from the Azure portal behavior. | `list(string)` | <pre>[<br>  "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26"<br>]</pre> | no |
| <a name="input_backup_enabled"></a> [backup\_enabled](#input\_backup\_enabled) | Enable backup for this Cosmos DB account | `bool` | `true` | no |
| <a name="input_backup_interval"></a> [backup\_interval](#input\_backup\_interval) | The interval in minutes between two backups. This is configurable only when type is Periodic. Possible values are between 60 and 1440. | `number` | `1440` | no |
| <a name="input_backup_retention"></a> [backup\_retention](#input\_backup\_retention) | The time in hours that each backup is retained. This is configurable only when type is Periodic. Possible values are between 8 and 720. | `number` | `336` | no |
| <a name="input_backup_storage_redundancy"></a> [backup\_storage\_redundancy](#input\_backup\_storage\_redundancy) | he storage redundancy which is used to indicate type of backup residency. This is configurable only when type is Periodic. Possible values are Geo, Local and Zone | `string` | `"Local"` | no |
| <a name="input_backup_type"></a> [backup\_type](#input\_backup\_type) | Type of backup - can be either Periodic or Continuous | `string` | `"periodic"` | no |
| <a name="input_capabilities"></a> [capabilities](#input\_capabilities) | Map of non-sql DB API to enable support for API other than SQL | `map(any)` | <pre>{<br>  "cassandra": "EnableCassandra",<br>  "gremlin": "EnableGremlin",<br>  "mongo": "EnableMongo",<br>  "sql": "SQL",<br>  "table": "EnableTable"<br>}</pre> | no |
| <a name="input_consistency_level"></a> [consistency\_level](#input\_consistency\_level) | The Consistency Level to use for this CosmosDB Account - can be either BoundedStaleness, Eventual, Session, Strong or ConsistentPrefix | `string` | `"Session"` | no |
| <a name="input_cosmos_account_name"></a> [cosmos\_account\_name](#input\_cosmos\_account\_name) | Name of the Cosmos DB account. | `string` | `""` | no |
| <a name="input_cosmos_api"></a> [cosmos\_api](#input\_cosmos\_api) | n/a | `string` | `"mongo"` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Whether to create resource group and use it for all networking resources | `bool` | `true` | no |
| <a name="input_enable_systemassigned_identity"></a> [enable\_systemassigned\_identity](#input\_enable\_systemassigned\_identity) | Enable System Assigned Identity | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of the environment. Example dev, test, qa, cert, prod etc.... | `string` | `"dev"` | no |
| <a name="input_firewall_ip"></a> [firewall\_ip](#input\_firewall\_ip) | List of ip address to allow access from the internet or on-premisis network. | `list(string)` | `[]` | no |
| <a name="input_free_tier"></a> [free\_tier](#input\_free\_tier) | Enable Free Tier pricing option for this Cosmos DB account - can be either true or false | `bool` | `false` | no |
| <a name="input_geo_locations"></a> [geo\_locations](#input\_geo\_locations) | List of map of geo locations and other properties to create primary and secodanry databasees. | `any` | <pre>[<br>  {<br>    "failover_priority": 0,<br>    "geo_location": "West Europe",<br>    "zone_redundant": false<br>  }<br>]</pre> | no |
| <a name="input_ip_firewall_enabled"></a> [ip\_firewall\_enabled](#input\_ip\_firewall\_enabled) | Enable ip firewwall to allow connection to this cosmosdb from client's machine and from azure portal. | `bool` | `true` | no |
| <a name="input_is_virtual_network_filter_enabled"></a> [is\_virtual\_network\_filter\_enabled](#input\_is\_virtual\_network\_filter\_enabled) | TODO | `bool` | `false` | no |
| <a name="input_local_authentication_disabled"></a> [local\_authentication\_disabled](#input\_local\_authentication\_disabled) | Local authentication flag | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Cosmos DB deployment region. Can be different vs. RG location | `string` | n/a | yes |
| <a name="input_mongo_server_version"></a> [mongo\_server\_version](#input\_mongo\_server\_version) | Version for the mongo db server and api | `number` | n/a | yes |
| <a name="input_multi_region_write"></a> [multi\_region\_write](#input\_multi\_region\_write) | Enable multiple write locations for this Cosmos DB account | `bool` | `false` | no |
| <a name="input_offer_type"></a> [offer\_type](#input\_offer\_type) | Type to use for this resource eg. Standard or Premium | `string` | `"Standard"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Used with environment and project in case more than one resources are required for same project in same environment. | `string` | `"01"` | no |
| <a name="input_privatelink_dns_name"></a> [privatelink\_dns\_name](#input\_privatelink\_dns\_name) | DNS Zone name for private link | `string` | n/a | yes |
| <a name="input_privatelink_subnet_name"></a> [privatelink\_subnet\_name](#input\_privatelink\_subnet\_name) | Subnet to create privatelink | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Three letter project key | `string` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enable public network access to cosmos db | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | A container that holds related resources for an Azure solution | `any` | n/a | yes |
| <a name="input_resource_group_name_hub"></a> [resource\_group\_name\_hub](#input\_resource\_group\_name\_hub) | Default network resource group to get the dns zone and subnet for privatelink | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | these tags are applied to every resource within this module | `map(string)` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the virtual network in which privatelink subnet and dns zone exists | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->