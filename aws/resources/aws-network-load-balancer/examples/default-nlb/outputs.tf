output "default_nlb_example_target_group_arn" {
  description = "The ARN of the Target Group for the nlb."
  value       = module.default_nlb_example.target_group_arn
}

output "default_nlb_example_nlb_arn" {
  description = "ARN of the Network Load Balancer."
  value       = module.default_nlb_example.nlb_arn
}

output "default_nlb_example_nlb_id" {
  description = "ID of the Network Load Balancer."
  value       = module.default_nlb_example.nlb_id
}

output "default_nlb_example_nlb_dns" {
  description = "DNS of the Network Load Balancer."
  value       = module.default_nlb_example.nlb_dns
}

output "default_nlb_example_nlb_zone_id" {
  description = "Zone ID of the Network Load Balancer."
  value       = module.default_nlb_example.nlb_zone_id
}

output "default_nlb_example_listener_arn" {
  description = "ARN of the Listener."
  value       = module.default_nlb_example.listener_arn
}

output "default_nlb_example_listener_id" {
  description = "ID of the TCP Listener."
  value       = module.default_nlb_example.listener_id
}

output "default_nlb_example_route53_record_name" {
  description = "The Name of the Route 53 Record."
  value       = module.default_nlb_example.route53_record_name
}

output "default_nlb_example_route53_record_fqdn" {
  description = "The Fully Qualified Domain Name of the Route 53 Record."
  value       = module.default_nlb_example.route53_record_fqdn
}
output "default_nlb_example_resource_name_prefix" {
  description = "Name of NLB"
  value       = module.default_nlb_example.resource_name_prefix
}

