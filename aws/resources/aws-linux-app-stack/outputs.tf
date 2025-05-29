output "dependency_id_for_codedeployment_status_complete" {
description = "The autoscaling group id."
  value       = var.deployment_type == "BLUE_GREEN" ? null_resource.Blue_Green_CodeDeploy_check.*.id : null_resource.Inplace_CodeDeploy_check.*.id
}

######################
# ASG security group #
######################
output "asg_sg_id" {
  description = "Auto scaling group security group"
  value       = element(concat(aws_security_group.this.*.id, [""]), 0)
}

#####################
# Launch Template #
#####################
output "launch_template_id" {
  description = "The ID of the launch template."
  value       = element(concat(aws_launch_template.this.*.id, [""]), 0)
}

output "launch_template_arn" {
  description = "Amazon Resource Name (ARN) of the launch template."
  value       = element(concat(aws_launch_template.this.*.arn, [""]), 0)
}

output "launch_template_default_version" {
  description = "The default version of the launch template."
  value       = element(concat(aws_launch_template.this.*.default_version, [""]), 0)
}

output "launch_template_latest_version" {
  description = "The latest version of the launch template."
  value       = element(concat(aws_launch_template.this.*.latest_version, [""]), 0)
}

######################
# Auto Scaling Groups #
######################
output "autoscaling_group_id" {
  description = "The autoscaling group id."
  value       = var.execute_microservice ? var.deployment_type == "BLUE_GREEN" ? concat(aws_autoscaling_group.this.*.id,aws_autoscaling_group.this_b.*.id) : aws_autoscaling_group.this.*.id : [""]
}

output "autoscaling_group_arn" {
  description = "The autoscaling group arn."
  value       = var.execute_microservice ? var.deployment_type == "BLUE_GREEN" ? concat(aws_autoscaling_group.this.*.arn,aws_autoscaling_group.this_b.*.arn) : aws_autoscaling_group.this.*.arn : [""]
}

output "autoscaling_group_name" {
  description = "The autoscaling group name."
  value       =  join("", aws_autoscaling_group.this.*.name)
}

output "autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done."
  value = var.execute_microservice ? var.deployment_type == "BLUE_GREEN" ? concat(aws_autoscaling_group.this.*.health_check_type,aws_autoscaling_group.this.*.health_check_type) : aws_autoscaling_group.this.*.health_check_type : [""]
}

output "asgtwo_name" {
  description = "The autoscaling group name."
  value       = join("", aws_autoscaling_group.this_b.*.name)
}

##########################
# ASG Termination Lambda #
##########################
output "dereg_lambda_name" {
  description = "ASG Deregistration Lambda name"
  value = element(concat(aws_lambda_function.dereg_lambda.*.function_name, [""]), 0)
}

output "dereg_lambda_arn" {
  description = "ASG Deregistration Lambda arn"
  value = element(concat(aws_lambda_function.dereg_lambda.*.arn, [""]), 0)
}

output "dereg_lambda_iam_role_name" {
  description = "ASG Deregistration Lambda IAM Role name"
  value = element(concat(aws_iam_role.dereg_lambda_role.*.name, [""]), 0)
}

output "dereg_lambda_iam_role_arn" {
  description = "ASG Deregistration Lambda IAM Role arn"
  value = element(concat(aws_iam_role.dereg_lambda_role.*.arn, [""]), 0)
}

output "dereg_lambda_iam_policy_name" {
  description = "ASG Deregistration Lambda IAM Policy name"
  value = element(concat(aws_iam_policy.dereg_lambda_policy.*.name, [""]), 0)
}

output "dereg_lambda_iam_policy_arn" {
  description = "ASG Deregistration Lambda IAM Policy arn"
  value = element(concat(aws_iam_policy.dereg_lambda_policy.*.arn, [""]), 0)
}

output "dereg_event_rule_name" {
  description = "ASG Deregistration Event Rule name"
  value = element(concat(aws_cloudwatch_event_rule.dereg_event_rule.*.name, [""]), 0)
}

output "dereg_event_rule_arn" {
  description = "ASG Deregistration Event Rule arn"
  value = element(concat(aws_cloudwatch_event_rule.dereg_event_rule.*.arn, [""]), 0)
}

###########################
# code deploy application #
###########################
output "code_deploy_application_id" {
  description = "Amazon's assigned ID for the application."
  value       = element(concat(aws_codedeploy_app.this.*.id, [""]), 0)
}

output "code_deploy_application_name" {
  description = "The application's name."
  value       = element(concat(aws_codedeploy_app.this.*.name, [""]), 0)
}

#############################
# code deploy group inplace #
#############################
output "inplace_code_deploy_group_id" {
  description = "The ID of the codedeploy deployment group"
  value = element(
    concat(aws_codedeploy_deployment_group.in_place.*.id, [""]),
    0,
  )
}

#################
# Code pipeline #
#################
output "in_place_code_pipeline_group_id" {
  description = "The codepipeline ID."
  value       = element(concat(aws_codepipeline.in_place.*.id, [""]), 0)
}

output "in_place_code_pipeline_group_arn" {
  description = "The codepipeline ARN."
  value       = element(concat(aws_codepipeline.in_place.*.arn, [""]), 0)
}

#####################
# Blue Green Lambda #
#####################
output "blue_green_lambda_function_arn" {
  description = "The arn of the lambda function created for blue green deployment"
  value = var.execute_microservice && var.deployment_type == "BLUE_GREEN" ? module.blue_green_deployment_lambda.arn : ""

}


output "asg_control_lambda_function_name" {
  description = "The name of ASG Control Lambda function for Blue Green"
  value = var.execute_microservice && var.deployment_type == "BLUE_GREEN" ? module.blue_green_asg_control_lambda.function_name : ""

}

