locals {
  elastic                 = data.terraform_remote_state.global.outputs.elastic
  virtual_network_name    = data.terraform_remote_state.global.outputs.virtual_network_name
  virtual_network_id      = data.terraform_remote_state.global.outputs.virtual_network_id
  resource_group_name_hub = data.terraform_remote_state.global.outputs.resource_group_name_hub
  firewall_private_ip     = data.terraform_remote_state.global.outputs.firewall_private_ip

  prometheus_workspace_id = data.terraform_remote_state.init.outputs.prometheus_workspace_id
}
