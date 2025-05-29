locals {

  scaling_policy = concat(var.scale_up_policy,var.scale_down_policy)

  scaling_alarm = concat(
  [
  for cpu_upscaling_alarm in var.cpu_upscaling_alarm : { 
      alarm_name           = cpu_upscaling_alarm.alarm_name
	  metric_name          = "CPUUtilization"
	  comparison_operator  = var.cpu_high_comparison_operator
	  namespace            = "AWS/EC2"
      period               =  cpu_upscaling_alarm.period
	  threshold            =  cpu_upscaling_alarm.threshold
	  description          = "This metric monitors ec2 CPU utilization and scales up the instances in ASG"
	}
  ],
  [
  for memory_upscaling_alarm in var.memory_upscaling_alarm : { 
      alarm_name           = memory_upscaling_alarm.alarm_name
	  metric_name          = "mem_used_percent"
	  comparison_operator  = var.memory_high_comparison_operator
	  namespace            = "CWAgent"
      period               =  memory_upscaling_alarm.period
	  threshold            =  memory_upscaling_alarm.threshold
	  description          = "This metric monitors ec2 memory utilization and scales up the instances in ASG"
	}
  ],
  [
  for cpu_downscaling_alarm in var.cpu_downscaling_alarm : { 
      alarm_name           = cpu_downscaling_alarm.alarm_name
	  metric_name          = "CPUUtilization"
	  comparison_operator  = var.cpu_low_comparison_operator
	  namespace            = "AWS/EC2"
      period             =  cpu_downscaling_alarm.period
	  threshold            =  cpu_downscaling_alarm.threshold
	  description          =  "This metric monitors ec2 CPU utilization and scales down the instances in ASG" 
	}
  ],
  [
  for memory_downscaling_alarm in var.memory_downscaling_alarm : { 
      alarm_name           = memory_downscaling_alarm.alarm_name
	  metric_name          = "mem_used_percent"
	  comparison_operator  = var.memory_low_comparison_operator
	  namespace            = "CWAgent"
      period               =  memory_downscaling_alarm.period
	  threshold            =  memory_downscaling_alarm.threshold
	  description          = "This metric monitors ec2 memory utilization and scales down the instances in ASG"
	}
  ]
  )
  
}

######################
# Auto Scaling Group #
######################
resource "aws_autoscaling_group" "this" {
  count = var.execute_microservice ? 1 : 0

  name                      = var.deployment_type == "IN_PLACE" ? format("%s-%s", var.resource_name_prefix, "ASG") : format("%s-%s", var.resource_name_prefix, "ASG-A")
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  target_group_arns         = var.target_group_arns
  vpc_zone_identifier       = flatten(var.private_subnets)
  
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.this[0].id}"
        version            = var.launch_template_version
      }

      dynamic "override" {
        for_each = var.spot_instance_types
        content {
          instance_type = override.value
        }
      }

    }

    instances_distribution {
      on_demand_allocation_strategy            = var.on_demand_allocation_strategy
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
      spot_allocation_strategy                 = var.spot_allocation_strategy
      spot_instance_pools                      = var.spot_instance_pools
      spot_max_price                           = var.spot_max_price
    }
  }

  tags = concat(
    list(
      map("key", "Name", "value", "${var.deployment_type == "IN_PLACE" ? format("%s-%s", var.resource_name_prefix, "ASG") : format("%s-%s", var.resource_name_prefix, "ASG-A")}", "propagate_at_launch", true),
      map("key", "depends_id", "value", var.depends_id, "propagate_at_launch", false)
    ),
    [for key, value in var.tags: {
      key                 = key
      value               = value
      propagate_at_launch = true
    }],
    var.asg_tags)

  lifecycle {
    create_before_destroy = true
  }
}

################################
# Auto Scaling lifecycle hooks #
################################
resource "aws_autoscaling_lifecycle_hook" "this_a" {
  count                   = var.execute_microservice && length(var.lifecycle_hook) > 0 ? length(var.lifecycle_hook) : 0
  name                    = lookup(var.lifecycle_hook[count.index], "name", "")
  autoscaling_group_name  = element(concat(aws_autoscaling_group.this.*.name, list("")), 0)
  default_result          = lookup(var.lifecycle_hook[count.index], "default_result", "")
  heartbeat_timeout       = lookup(var.lifecycle_hook[count.index], "heartbeat_timeout", "")
  lifecycle_transition    = lookup(var.lifecycle_hook[count.index], "lifecycle_transition")
  notification_target_arn = lookup(var.lifecycle_hook[count.index], "notification_target_arn", "")
  role_arn                = lookup(var.lifecycle_hook[count.index], "role_arn", "")
  notification_metadata   = lookup(var.lifecycle_hook[count.index], "notification_metadata", "")
}


###############################
# Auto Scaling Group Policies #
###############################

resource "aws_autoscaling_policy" "this" {
  count                  = var.execute_microservice && length(local.scaling_policy) > 0 ? length(local.scaling_policy) : 0
  name                   = var.deployment_type == "IN_PLACE" ? lookup(local.scaling_policy[count.index], "name") : format("%s-%s", lookup(local.scaling_policy[count.index], "name"), "a")
  autoscaling_group_name = element(concat(aws_autoscaling_group.this.*.name, list("")), 0)
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = lookup(local.scaling_policy[count.index],"scaling_adjustment")
  cooldown               = lookup(local.scaling_policy[count.index],"cooldown")
  policy_type            = "SimpleScaling"
}


resource "aws_cloudwatch_metric_alarm" "this" {
  count               = var.execute_microservice && length(local.scaling_alarm) > 0 ? length(local.scaling_alarm) : 0
  alarm_name          = var.deployment_type == "IN_PLACE" ? format("%s-%s", var.resource_name_prefix, lookup(local.scaling_alarm[count.index], "alarm_name")) : format("%s-%s-%s", var.resource_name_prefix, lookup(local.scaling_alarm[count.index], "alarm_name"), "a")
  comparison_operator = lookup(local.scaling_alarm[count.index],"comparison_operator")
  evaluation_periods  = "1"
  metric_name         = lookup(local.scaling_alarm[count.index],"metric_name","")
  namespace           = lookup(local.scaling_alarm[count.index],"namespace","")
  period              = lookup(local.scaling_alarm[count.index],"period", "")
  statistic           = "Average"
  threshold           = lookup(local.scaling_alarm[count.index],"threshold", "")
  
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.this[0].name}"
  }

  alarm_description = lookup(local.scaling_alarm[count.index],"description","")
  alarm_actions     = ["${aws_autoscaling_policy.this[count.index].arn}"]
}


resource "aws_autoscaling_schedule" "this_a" {
  count                  = var.execute_microservice && length(var.scheduled_action) > 0 ? length(var.scheduled_action) : 0
  scheduled_action_name  = lookup(var.scheduled_action[count.index], "scheduled_action_name", "")
  autoscaling_group_name = element(concat(aws_autoscaling_group.this.*.name, list("")), 0)
  min_size               = lookup(var.scheduled_action[count.index], "min_size", "")
  max_size               = lookup(var.scheduled_action[count.index], "max_size", "")
  desired_capacity       = lookup(var.scheduled_action[count.index], "desired_capacity", "")
  start_time             = lookup(var.scheduled_action[count.index], "start_time", "")
  end_time               = lookup(var.scheduled_action[count.index], "end_time", "")
  recurrence             = lookup(var.scheduled_action[count.index], "recurrence", "")
}

resource "aws_autoscaling_notification" "this_a" {
  count                  = var.execute_microservice && var.autoscaling_notification_topic_arn != "" ? 1:0
  group_names = [
    element(concat(aws_autoscaling_group.this.*.name, list("")), 0),
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = var.autoscaling_notification_topic_arn
}

##########################
# CodeDeploy Application #
##########################
resource "aws_codedeploy_app" "this" {
  count            = var.execute_microservice ? 1 : 0

  name             = format("%s-%s", var.resource_name_prefix, "CD-APP")
  compute_platform = var.codedeploy_compute_platform
}

############################################
# CodeDeploy Deployment Group for IN_PLACE #
############################################
resource "aws_codedeploy_deployment_group" "in_place" {
  count                  = var.execute_microservice && var.create_codedeploy && var.deployment_type == "IN_PLACE" ? 1 : 0

  app_name               = local.codeDeployApplicationName
  deployment_group_name  = format("%s-%s", var.resource_name_prefix, "CD-GROUP")
  service_role_arn       = var.service_role_arn
  autoscaling_groups     = [element(concat(aws_autoscaling_group.this.*.name, list("")), 0)]
  deployment_config_name = var.deployment_config_name

  auto_rollback_configuration {
    enabled = var.rollback_option
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_type   = var.deployment_type
    deployment_option = var.deployment_option
  }
}

#############################
# CodePipeline for IN_PLACE #
#############################
resource "aws_codepipeline" "in_place" {
  count = var.execute_microservice && var.create_codedeploy && var.deployment_type == "IN_PLACE" ? 1 : 0

  depends_on = [
    aws_codedeploy_deployment_group.in_place,
    aws_codedeploy_app.this,
    aws_autoscaling_group.this,
  ]
  name     = local.codePipelineName
  role_arn = var.service_role_arn
  tags = merge(
    var.tags,
    {
      "TenantCode" = var.tenant_code
    },
    {
      "depends_id" = var.depends_id
    },
    {
      "AppCode" = "${var.tenant_code}-CP"
    }
  )

  artifact_store {
    location = var.artifacts_store_location
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "ApplicationSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["ApplicationArtifacts"]
      run_order        = 1

      configuration = {
        S3Bucket    = var.source_s3_bucket
        S3ObjectKey = var.source_s3_object_key
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "ApplicationDeploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["ApplicationArtifacts"]
      version         = "1"

      configuration = {
        ApplicationName     = local.codeDeployApplicationName
        DeploymentGroupName = local.codeDeployGroupName
      }
    }
  }
}

##################################################
# Check Code Pipeline Execution Status - INPLACE #
##################################################
resource "null_resource" "Inplace_CodeDeploy_check" {

  count = var.execute_microservice && var.create_codedeploy && var.enable_codedeploy_check && var.deployment_type == "IN_PLACE" ? 1 : 0

  depends_on = [
    null_resource.change_script_permission,
    aws_autoscaling_group.this,
    aws_codedeploy_app.this,
    aws_codedeploy_deployment_group.in_place,
    aws_codepipeline.in_place
    ]
  provisioner "local-exec" {
    command = "${path.module}/files/bluegreen/CheckInplaceDeploymentStatus.sh  \"${var.access_key}\" \"${var.secret_key}\" \"${var.token}\" ${local.codePipelineName} ${var.region} "
  }
}