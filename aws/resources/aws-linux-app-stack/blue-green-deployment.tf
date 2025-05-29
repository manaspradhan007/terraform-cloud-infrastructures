locals {
  asgONE 					= join("", aws_autoscaling_group.this.*.name)
  asgTWO          = join("", aws_autoscaling_group.this_b.*.name)
}

######################
# Auto Scaling Group #
######################
resource "aws_autoscaling_group" "this_b" {
  count                     = var.execute_microservice && var.deployment_type == "BLUE_GREEN" ? 1 : 0

  name                      = format("%s-%s", var.resource_name_prefix, "ASG-B")
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
      map("key", "Name", "value", format("%s-%s", var.resource_name_prefix, "ASG-B"), "propagate_at_launch", true),
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
resource "aws_autoscaling_lifecycle_hook" "this_b" {
  count                  = var.execute_microservice && var.deployment_type == "BLUE_GREEN" && length(var.lifecycle_hook) > 0 ? length(var.lifecycle_hook) : 0
  name                   = lookup(var.lifecycle_hook[count.index],"name", "")
  autoscaling_group_name = element(concat(aws_autoscaling_group.this_b.*.name, list("")), 0)
  default_result         = lookup(var.lifecycle_hook[count.index],"default_result","")
  heartbeat_timeout      = lookup(var.lifecycle_hook[count.index],"heartbeat_timeout","")
  lifecycle_transition   = lookup(var.lifecycle_hook[count.index],"lifecycle_transition")
  notification_target_arn = lookup(var.lifecycle_hook[count.index],"notification_target_arn","")
  role_arn                = lookup(var.lifecycle_hook[count.index],"role_arn","")
  notification_metadata   = lookup(var.lifecycle_hook[count.index],"notification_metadata","")
}

##########################################
# Auto Scaling Group Policies and Alarms #
##########################################

resource "aws_autoscaling_policy" "this_b" {
  count                  = var.execute_microservice && var.deployment_type == "BLUE_GREEN" && length(local.scaling_policy) > 0  ? length(local.scaling_policy) : 0
  name                   = format("%s-%s", lookup(local.scaling_policy[count.index], "name"), "b")
  autoscaling_group_name = element(concat(aws_autoscaling_group.this_b.*.name, list("")), 0)
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = lookup(local.scaling_policy[count.index],"scaling_adjustment")
  cooldown               = lookup(local.scaling_policy[count.index],"cooldown")
  policy_type            = "SimpleScaling"
}


resource "aws_cloudwatch_metric_alarm" "this_b" {
  count               = var.execute_microservice && var.deployment_type == "BLUE_GREEN" && length(local.scaling_alarm) > 0 ? length(local.scaling_alarm) : 0
  alarm_name          = format("%s-%s-%s", var.resource_name_prefix, lookup(local.scaling_alarm[count.index], "alarm_name"), "b")
  comparison_operator = lookup(local.scaling_alarm[count.index],"comparison_operator")
  evaluation_periods  = "1"
  metric_name         = lookup(local.scaling_alarm[count.index],"metric_name","")
  namespace           = lookup(local.scaling_alarm[count.index],"namespace","")
  period              = lookup(local.scaling_alarm[count.index],"period", "")
  statistic           = "Average"
  threshold           = lookup(local.scaling_alarm[count.index],"threshold", "")
  
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.this_b[0].name}"
  }

  alarm_description = lookup(local.scaling_alarm[count.index],"description","")
  alarm_actions     = ["${aws_autoscaling_policy.this_b[count.index].arn}"]
}

resource "aws_autoscaling_schedule" "this_b" {
  count                  = var.execute_microservice && var.deployment_type == "BLUE_GREEN" && length(var.scheduled_action) > 0 ? length(var.scheduled_action) : 0
  scheduled_action_name  = lookup(var.scheduled_action[count.index],"scheduled_action_name", "")
  autoscaling_group_name = element(concat(aws_autoscaling_group.this_b.*.name, list("")), 0)
  min_size               = lookup(var.scheduled_action[count.index], "min_size", "")
  max_size               = lookup(var.scheduled_action[count.index], "max_size", "")
  desired_capacity       = lookup(var.scheduled_action[count.index], "desired_capacity", "")
  start_time             = lookup(var.scheduled_action[count.index], "start_time", "")
  end_time               = lookup(var.scheduled_action[count.index], "end_time", "")
  recurrence             = lookup(var.scheduled_action[count.index], "recurrence", "")
}

resource "aws_autoscaling_notification" "this_b" {
  count                  = var.execute_microservice && var.deployment_type == "BLUE_GREEN" && var.autoscaling_notification_topic_arn != "" ? 1:0
  group_names = [
    element(concat(aws_autoscaling_group.this_b.*.name, list("")), 0),
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = var.autoscaling_notification_topic_arn
}

module "blue_green_lambda_iam_role" {
  source   = "git::ssh://<your-git-repo-url-here>/lmd/terraform-aws-iam-role.git?ref=v2.0.3"

  execute_microservice = var.execute_microservice && var.deployment_type == "BLUE_GREEN" ? true : false
  resource_name_prefix = format("%s-%s", var.resource_name_prefix, "BLUE_GREEN-LAMBDA-ROLE")
  
  principals_arn_required = false
  principals_services_arns = ["lambda.amazonaws.com"]
  aws_managed_policy_names = ["AmazonEC2FullAccess"]
  tags = var.tags
  custom_policy_json       =<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWS",
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "iam:*",
                "logs:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "ssm:*",
                "codedeploy:*",
                "lambda:*",
                "codepipeline:*",
                "ec2:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


module "blue_green_deployment_lambda" {
  source   = "git::ssh://<your-git-repo-url-here>/lmd/terraform-aws-lambda-function.git?ref=v2.0.3"
  
  execute_microservice = var.execute_microservice && var.deployment_type == "BLUE_GREEN" ? true : false
  
  resource_name_prefix  = format("%s-%s", var.resource_name_prefix, "BLUE-GREEN")
  file_name             = "${path.module}/files/bluegreen/bluegreen-lambda/bluegreenlambda.zip"
  handler               = "lambda_function.lambda_handler"
  role_arn              =  module.blue_green_lambda_iam_role.iam_role_arn
  runtime               = "python3.6"
  timeout               = 300
  environment_variables = {"ApplicationTargetGroupName" = data.aws_lb_target_group.get_tg_name.name, "applicationName" = local.codeDeployApplicationName, "artifactsBucketname" = var.source_s3_bucket, "artifactPath" = var.source_s3_object_key,
                            "asgone" = join("", aws_autoscaling_group.this.*.name), "asgtwo" = join("", aws_autoscaling_group.this_b.*.name) , "codedeployIAMRoleARN" = var.service_role_arn,
                             "deploymentGroupName" = local.codeDeployGroupName, "tgARN" = join(" ",var.target_group_arns), "SNSArn" = join(" ",aws_sns_topic.deploymentsuccesstopic.*.arn)  }
}


data "aws_lb_target_group" "get_tg_name" {
  arn  = var.target_group_arns[0]
}

resource "null_resource" "delay_for_lambda_creation" {
  count=var.execute_microservice ? 1 : 0
  depends_on = [module.blue_green_deployment_lambda]

  provisioner "local-exec" {
    command = "sleep 120"
  }

}

module "blue_green_asg_lambda_iam_role" {
  source   = "git::ssh://<your-git-repo-url-here>/lmd/terraform-aws-iam-role.git?ref=v2.0.3"

  execute_microservice = var.execute_microservice && var.deployment_type == "BLUE_GREEN" ? true : false
  resource_name_prefix = format("%s-%s", var.resource_name_prefix, "BLUE-GREEN-ASG-CONTROL-ROLE")
  
  principals_arn_required = false
  principals_services_arns = ["lambda.amazonaws.com"]
  aws_managed_policy_names = ["AmazonEC2FullAccess"]
  tags = var.tags
  custom_policy_json       =<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWS",
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "iam:*",
                "logs:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "ssm:*",
                "codedeploy:*",
                "lambda:*",
                "codepipeline:*",
                "ec2:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


module "blue_green_asg_control_lambda" {
  source   = "git::ssh://<your-git-repo-url-here>/lmd/terraform-aws-lambda-function.git?ref=v2.0.3"
  
  execute_microservice = var.execute_microservice && var.deployment_type == "BLUE_GREEN" ? true : false
  
  resource_name_prefix  = format("%s-%s", var.resource_name_prefix, "BLUE-GREEN-ASG-CONTROL")
  file_name             = "${path.module}/files/bluegreen/bluegreenASGControl-lambda/asgcontrolLambda.zip"
  handler               = "lambda_function.lambda_handler"
  role_arn              =  module.blue_green_asg_lambda_iam_role.iam_role_arn
  runtime               = "python3.6"
  timeout               = 300
  environment_variables = {"applicationName" = local.codeDeployApplicationName, "asgone" = join("", aws_autoscaling_group.this.*.name), "asgtwo" = join("", aws_autoscaling_group.this_b.*.name) ,
                           "deploymentGroupName" = local.codeDeployGroupName, "tgARNs" = join(" ",var.target_group_arns)   }
  tags                  = {"depends_id" = var.execute_microservice ? null_resource.delay_for_lambda_creation[0].id : " "}
}
  
  

#############################################
# BLUE_GREEN ASG CONTROL Lambda SNS trigger #
#############################################
resource "aws_sns_topic" "deploymentsuccesstopic" {

  count         = var.execute_microservice && var.create_codedeploy && var.deployment_type == "BLUE_GREEN" ? 1 : 0
  name          = "${var.tenant_code}-DEPLOYMENTSUCCESSTOPIC-BLUEGREEN"
}

resource "aws_sns_topic_policy" "default_for_bg" {

  count         = var.execute_microservice && var.create_codedeploy && var.deployment_type == "BLUE_GREEN" ? 1 : 0
  arn           = join(" ",aws_sns_topic.deploymentsuccesstopic.*.arn)

  policy = <<EOF
{  
   "Version":"2012-10-17",
   "Statement":[  
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "autoscaling.amazonaws.com",
          "codedeploy.amazonaws.com",
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sns:Publish",
      "Resource": "${join(" ",aws_sns_topic.deploymentsuccesstopic.*.arn)}"
    }
   ]
}
EOF

}

resource "aws_sns_topic_subscription" "blue_green_user_updates_sqs_target" {
  count         = var.execute_microservice && var.create_codedeploy && var.deployment_type == "BLUE_GREEN" ? 1 : 0

  topic_arn     = join(" ",aws_sns_topic.deploymentsuccesstopic.*.arn)
  protocol      = "lambda"
  endpoint      = module.blue_green_asg_control_lambda.arn
}

module "blue_green_asg_control_lambda_sns_trigger" {
  source         = "git::ssh://<your-git-repo-url-here>/lmd/terraform-aws-lambda-trigger.git?ref=v2.1.0"
  
  trigger_type = var.execute_microservice && var.deployment_type == "BLUE_GREEN" ? "SNS" : ""
  function_name = module.blue_green_asg_control_lambda.function_name
  trigger_arn   = join(" ",aws_sns_topic.deploymentsuccesstopic.*.arn)
}



#####################################################
# Check Code Pipeline Execution Status - BLUE-GREEN #
#####################################################
resource "null_resource" "Blue_Green_CodeDeploy_check" {

  count = var.execute_microservice && var.create_codedeploy && var.enable_codedeploy_check && var.deployment_type == "BLUE_GREEN" ? 1 : 0

  depends_on = [
    null_resource.change_script_permission,
    aws_autoscaling_group.this,
    aws_autoscaling_group.this_b,
    aws_codedeploy_app.this,
    module.blue_green_lambda_iam_role,
    module.blue_green_deployment_lambda,
    module.blue_green_asg_control_lambda,


    ]
  provisioner "local-exec" {
    command = "${path.module}/files/bluegreen/CheckBlueGreenDeploymentStatus.sh ${var.access_key} ${var.secret_key} ${var.token} ${local.codeDeployApplicationName} ${local.codeDeployGroupName} ${local.asgONE} ${local.asgTWO} ${var.source_s3_bucket} ${module.blue_green_deployment_lambda.function_name} ${var.region}"
  }
}







