module "functionAppLinux" {
  source                               = "git::https://git.<some-name-here>.com/devops1/<some-name-here>-infra-modules.git//sub-modules/azure-resources/azure-functions/linux?ref=master"
  project                              = "devops"
  resource_group_name_hub              = var.resource_group_name_hub
  resource_group_name                  = var.resource_group_name
  tags                                 = var.tags
  sku                                  = var.sku
  functionapp_subnet_address           = var.functionapp_subnet_address
  storage_account_name                 = var.storage_account_name
  function_app                         = var.function_app
  network_name_hub                     = var.network_name_hub
  env                                  = var.env
  function_app_language                = var.function_app_language
  devops-storage-private-endpoint-name = var.devops-storage-private-endpoint-name
  application_insights_type            = var.application_insights_type
  function_app_application_settings    = var.function_app_application_settings
}