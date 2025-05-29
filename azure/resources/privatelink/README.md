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
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_dns_zone.privatelink_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_subnet.privatelink_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Name of the environment. Example dev, test, qa, cert, prod etc.... | `string` | n/a | yes |
| <a name="input_is_manual_connection"></a> [is\_manual\_connection](#input\_is\_manual\_connection) | Used when private link is created for something deployed on virtual machines | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Cosmos DB deployment region. Can be different vs. RG location | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | name for private link | `string` | n/a | yes |
| <a name="input_privatelink_dns_name"></a> [privatelink\_dns\_name](#input\_privatelink\_dns\_name) | DNS Zone name for private link | `string` | n/a | yes |
| <a name="input_privatelink_subnet_name"></a> [privatelink\_subnet\_name](#input\_privatelink\_subnet\_name) | Subnet to create privatelink | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Three letter project key | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | A container that holds related resources for an Azure solution | `any` | n/a | yes |
| <a name="input_resource_group_name_hub"></a> [resource\_group\_name\_hub](#input\_resource\_group\_name\_hub) | Default network resource group to get the dns zone and subnet for privatelink | `string` | n/a | yes |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | Resource id for which creating this private link | `string` | n/a | yes |
| <a name="input_subresource_names"></a> [subresource\_names](#input\_subresource\_names) | List of subresource names like, blob, fileshare, mongo etc. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | these tags are applied to every resource within this module | `map(string)` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the virtual network in which privatelink subnet and dns zone exists | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->