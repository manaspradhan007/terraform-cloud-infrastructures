##########
# Common #
##########
variable "execute_microservice" {
  description = "Main switch to control the execution of this microservice based on consumer logic."
  default     = true
}

variable "create_security_group" {
  description = "If you have security group and dont want to create inside then make it false"
  default     = true
}

variable "resource_name_prefix" {
  description = "Name prefix to be used to derive names for all the resources."
  default     = ""
}

variable "vpc_id" {
  description = "The VPC id to be used for default TG and default SG creation."
  default     = ""
}

################
# Target Group #
################
variable "tg_arn" {
  description = "ARN of the Target Group for the listner. One will be created if empty."
  default     = ""
}

variable "default_tg_target_type" {
  description = "The target type indicates whether targets are registered using instance IDs or private IP addresses."
  default     = "instance"
}

variable "default_tg_protocol" {
  description = "The protocol the load balancer uses when routing traffic to targets in the default target group."
  default     = "TCP"
}

variable "default_tg_port" {
  description = "The port the load balancer uses when routing traffic to targets in the default target group."
  default     = "22"
}

variable "default_listener_port" {
  description = "The port for the load balancer listener."
  default     = "80"
}

variable "default_tg_stickiness" {
  description = "The settings to be used for default target group stickiness."
  default = [
    {
      enabled         = false
      type            = "lb_cookie"
      cookie_duration = 86400
    },
  ]
}

variable "default_tg_healthcheck" {
  description = "The settings to be used for default target group health check."
  default = [
    {
      interval            = 30
      protocol            = "TCP"
      port                = 22
      healthy_threshold   = 3
      unhealthy_threshold = 3
    },
  ]
}

#######
# NLB #
#######
variable "nlb_is_internal" {
  description = "Controls if nlb should be created as Internal or Internet facing."
  default     = "true"
}

variable "subnet_ids" {
  description = "A list of Subnet IDs to attach to the nlb. Private Subnets for Internal or Public Subnets for Internet facing."
  default     = []
}

variable "nlb_idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  default     = "60"
}

variable "nlb_enable_deletion_protection" {
  description = "Enable deletion protection for nlb."
  default     = "false"
}

variable "nlb_enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
  default     = "true"
}

variable "nlb_ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
  default     = "ipv4"
}

variable "nlb_access_log_bucket" {
  description = "Bucket for storing access log for nlb."
  default     = "tenant-nlb-accesslogs"
}

variable "nlb_enable_access_log" {
  description = "Enable access log for nlb."
  default     = "true"
}

variable "nlb_enable_cross_zone_load_balancing" {
  description = "Enable cross zone for nlb."
  default     = "true"
}

#################
# TCP Listener #
#################
variable "tcp_listener_protocol" {
  description = "NLB TCP listerner protocol."
  default     = "TCP"
}

variable "tcp_listener_port" {
  description = "NLB TCP listerner port."
  default     = "22"
}

variable "tcp_listener_default_action_type" {
  description = "NLB TCP listerner default action."
  default     = "forward"
}

##################
# TLS Listener #
##################
variable "tls_listener_protocol" {
  description = "NLB TLS listener protocol."
  default     = "TLS"
}

variable "tls_listener_port" {
  description = "NLB TLS listener port."
  default     = "443"
}

variable "tls_listener_ssl_policy" {
  description = "NLB TLS listener SSL policy name."
  default     = ""
}

variable "tls_listener_certificate_arn" {
  description = "NLB TLS listener SSL certificate ARN."
  default     = "arn:aws:acm:us-east-1:891105499989:certificate/58ae2d65-9af3-4891-9d18-f7afaa0261ee"
}

variable "tls_listener_default_action_type" {
  description = "TLS listerner default action."
  default     = "forward"
}

############
# Route 53 #
############
variable "create_route53_record" {
  description = "Controls if Route 53 record should be created."
  default     = true
}

variable "route53_record_type" {
  description = "The type of the Route 53 record."
  default     = "CNAME"
}

variable "route53_record_ttl" {
  description = "The TTL of the Route 53 record."
  default     = "3600"
}

variable "route53_zone_id" {
  description = "The ID of the Hosted zone for the Route 53 record."
  default     = ""
}

variable "route53_record_name" {
  description = "The Name of the Route 53 record."
  default     = ""
}

########
# Tags #
########
variable "tags" {
  description = "A map of tags to add to all resources."
  default     = {}
}

variable "default_tg_tags" {
  description = "Additional tags for the Target Group."
  default     = {}
}

variable "default_sg_tags" {
  description = "Additional tags for the Security Group."
  default     = {}
}

variable "nlb_tags" {
  description = "Additional tags for the Application Load Balancer."
  default     = {}
}

