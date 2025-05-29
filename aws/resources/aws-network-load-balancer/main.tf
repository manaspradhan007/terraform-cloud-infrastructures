locals {
  tg_arn = element(
    coalescelist(aws_lb_target_group.this.*.arn, [var.tg_arn]),
    0,
  )
}

################
# Target Group #
################
resource "aws_lb_target_group" "this" {
  count = var.execute_microservice && var.tg_arn == "" ? 1 : 0

  name        = format("%s-%s", var.resource_name_prefix, "TG")
  vpc_id      = var.vpc_id
  protocol    = var.default_tg_protocol
  port        = var.default_tg_port
  target_type = var.default_tg_target_type
  dynamic "stickiness" {
    for_each = var.default_tg_stickiness
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
      enabled         = lookup(stickiness.value, "enabled", null)
      type            = stickiness.value.type
    }
  }
  dynamic "health_check" {
    for_each = var.default_tg_healthcheck
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      enabled             = lookup(health_check.value, "enabled", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      interval            = lookup(health_check.value, "interval", null)
      matcher             = lookup(health_check.value, "matcher", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      protocol            = lookup(health_check.value, "protocol", null)
      timeout             = lookup(health_check.value, "timeout", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
    }
  }
  tags = merge(
    {
      "Name" = format("%s-%s", var.resource_name_prefix, "TG")
    },
    var.tags,
    var.default_tg_tags,
  )
}

#######
# NLB #
#######
resource "aws_lb" "this" {
  count = var.execute_microservice ? 1 : 0

  name                             = format("%s-%s", var.resource_name_prefix, "NLB")
  internal                         = var.nlb_is_internal
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = var.nlb_enable_cross_zone_load_balancing
  subnets                          = var.subnet_ids
  idle_timeout                     = var.nlb_idle_timeout
  enable_deletion_protection       = var.nlb_enable_deletion_protection

  ip_address_type = var.nlb_ip_address_type
  access_logs {
    bucket  = var.nlb_access_log_bucket
    enabled = var.nlb_enable_access_log
  }
  tags = merge(
    {
      "Name" = format("%s-%s", var.resource_name_prefix, "NLB")
    },
    var.tags,
    var.nlb_tags,
  )
}

#################
# TCP Listener #
#################
resource "aws_lb_listener" "tcp_listener" {
  count = var.execute_microservice && var.nlb_is_internal ? 1 : 0

  load_balancer_arn = aws_lb.this[0].arn
  port              = var.default_listener_port
  protocol          = var.default_tg_protocol

  default_action {
    type             = var.tcp_listener_default_action_type
    target_group_arn = local.tg_arn
  }
}

##################
# TLS Listener #
##################
resource "aws_lb_listener" "tls_listener" {
  count = var.execute_microservice && !var.nlb_is_internal ? 1 : 0

  load_balancer_arn = element(concat(aws_lb.this.*.arn, [""]), 0)
  port              = var.tls_listener_port
  protocol          = var.tls_listener_protocol
  ssl_policy        = var.tls_listener_ssl_policy
  certificate_arn   = var.tls_listener_certificate_arn

  default_action {
    type             = var.tls_listener_default_action_type
    target_group_arn = local.tg_arn
  }
}

###################
# Route 53 Record #
###################
resource "aws_route53_record" "this" {
  provider = aws.route53

  count = var.execute_microservice && var.create_route53_record ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.route53_record_name
  type    = var.route53_record_type
  ttl     = var.route53_record_ttl
  records = aws_lb.this.*.dns_name
}


