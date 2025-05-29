module "functionAppWindows" {
    source = "git::https://git.<some-name-here>.com/devops1/<some-name-here>-infra-modules.git//sub-modules/azure-resources/azure-functions/windows?ref=master"
    project                                         = "devops"
    resource_group_name_hub                         = var.resource_group_name_hub
    resource_group_name                             = var.resource_group_name
    tags                                            = var.tags
    functionapp_subnet_address                      = var.functionapp_subnet_address
    storage_account_name                            = var.storage_account_name
    function_app                                    = var.function_app
    network_name_hub                                = var.network_name_hub
    env                                             = var.env
    devops_storage_private_endpoint_name            = var.devops_storage_private_endpoint_name
    application_insights_type                       = var.application_insights_type
    function_app_application_settings               = var.function_app_application_settings
}