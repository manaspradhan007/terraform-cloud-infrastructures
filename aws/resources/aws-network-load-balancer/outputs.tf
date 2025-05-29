################
# Target Group #
################
output "target_group_arn" {
  description = "The ARN of the Target Group for the nlb."
  value       = local.tg_arn
}

#######
# nlb #
#######
output "nlb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = element(concat(aws_lb.this.*.arn, [""]), 0)
}

output "nlb_id" {
  description = "ID of the Application Load Balancer."
  value       = element(concat(aws_lb.this.*.id, [""]), 0)
}

output "resource_name_prefix" {
  description = "The name of the NLB"
  value = element(concat(aws_lb.this.*.name, [""]), 0)
}


output "nlb_dns" {
  description = "DNS of the Application Load Balancer."
  value       = element(concat(aws_lb.this.*.dns_name, [""]), 0)
}

output "nlb_zone_id" {
  description = "Zone ID of the Application Load Balancer."
  value       = element(concat(aws_lb.this.*.zone_id, [""]), 0)
}

############
# Listener #
############
output "listener_arn" {
  description = "ARN of the Listener."
  value = element(
    concat(
      aws_lb_listener.tcp_listener.*.arn,
      aws_lb_listener.tls_listener.*.arn,[""]
    ),
    0,
  )
}

output "listener_id" {
  description = "ID of the HTTP Listener."
  value = element(
    concat(
      aws_lb_listener.tcp_listener.*.id,
      aws_lb_listener.tls_listener.*.id,[""]
    ),
    0,
  )
}

############
# Route 53 #
############
output "route53_record_name" {
  description = "The Name of the Route 53 Record."
  value       = element(concat(aws_route53_record.this.*.name, [""]), 0)
}

output "route53_record_fqdn" {
  description = "The Fully Qualified Domain Name of the Route 53 Record."
  value       = element(concat(aws_route53_record.this.*.fqdn, [""]), 0)
}

