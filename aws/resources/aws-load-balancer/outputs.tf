##################################
# Common Load Balancer Outputs #
##################################
output "loadbalancer_resource_group_id" {
  value = ["${azurerm_resource_group.loadbalancer_rg.id}"]
}



##################################
# External Load Balancer Outputs #
##################################

output "external_loadbalancer_id" {
  value = ["${azurerm_lb.elb.*.id}"]
}

output "external_loadbalancer_ip_address" {
  value = ["${azurerm_public_ip.lb_public_ip.*.ip_address}"]
}

output "external_loadbalancer_fqdn" {
  value = ["${azurerm_public_ip.lb_public_ip.*.fqdn}"]
}

output "external_loadbalancer_resource_tags" {
  value = ["${azurerm_lb.elb.*.tags}"]
}

output "external_loadbalancer_frontend_ip_configuration" {
  value = ["${azurerm_lb.elb.*.frontend_ip_configuration}"]
}

output "external_loadbalancer_backend_pool_id" {
  value = ["${azurerm_lb_backend_address_pool.elb_be_pool.*.id}"]
}


##################################
# Internal Load Balancer Outputs #
##################################

output "internal_loadbalancer_id" {
  value = ["${azurerm_lb.ilb.*.id}"]
}

output "internal_loadbalancer_ip_address" {
  value = ["${azurerm_lb.ilb.*.private_ip_address}"]
}

output "internal_loadbalancer_backend_pool_id" {
  value = ["${azurerm_lb_backend_address_pool.ilb_be_pool.*.id}"]
}
