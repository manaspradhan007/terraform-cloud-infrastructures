######################
# ASG security group #
######################
output "default_linux_appstack_ex_asg_sg_id" {
  description = "Auto scaling group security group"
  value       = module.default_linux_appstack_ex.asg_sg_id
}

#####################
# Launch Template ###
#####################
output "default_linux_appstack_ex_launch_template_id" {
  description = "The ID of the launch template."
  value       =  module.default_linux_appstack_ex.launch_template_id
}

output "default_linux_appstack_ex_launch_template_arn" {
  description = "Amazon Resource Name (ARN) of the launch template."
  value       = module.default_linux_appstack_ex.launch_template_arn
}

output "default_linux_appstack_ex_launch_template_default_version" {
  description = "The default version of the launch template."
  value       = module.default_linux_appstack_ex.launch_template_default_version
}

output "default_linux_appstack_ex_launch_template_latest_version" {
  description = "The latest version of the launch template."
  value       = module.default_linux_appstack_ex.launch_template_latest_version
}
######################
# Auto Scaling Group #
######################
output "default_linux_appstack_ex_autoscaling_group_id" {
  description = "The autoscaling group id."
  value       = module.default_linux_appstack_ex.autoscaling_group_id
}

output "default_linux_appstack_ex_autoscaling_group_arn" {
  description = "The autoscaling group arn."
  value       = module.default_linux_appstack_ex.autoscaling_group_arn
}

output "default_linux_appstack_ex_autoscaling_group_name" {
  description = "The autoscaling group name."
  value       = module.default_linux_appstack_ex.autoscaling_group_name
}

output "default_linux_appstack_ex_autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done."
  value       = module.default_linux_appstack_ex.autoscaling_group_health_check_type
}

############################
# ASG Dergistration Lambda #
############################
output "default_linux_appstack_ex_dereg_lambda_name" {
  description = "ASG Deregistration Lambda name"
  value       = module.default_linux_appstack_ex.dereg_lambda_name
}

output "default_linux_appstack_ex_dereg_lambda_arn" {
  description = "ASG Deregistration Lambda arn"
  value       = module.default_linux_appstack_ex.dereg_lambda_arn
}

output "default_linux_appstack_ex_dereg_lambda_iam_role_name" {
  description = "ASG Deregistration IAM Role name"
  value       = module.default_linux_appstack_ex.dereg_lambda_iam_role_name
}

output "default_linux_appstack_ex_dereg_lambda_iam_role" {
  description = "ASG Deregistration IAM Role arn"
  value       = module.default_linux_appstack_ex.dereg_lambda_iam_role_arn
}

output "default_linux_appstack_ex_dereg_lambda_iam_policy_name" {
  description = "ASG Deregistration IAM Policy name"
  value       = module.default_linux_appstack_ex.dereg_lambda_iam_policy_name
}

output "default_linux_appstack_ex_dereg_lambda_iam_policy" {
  description = "ASG Deregistration IAM Policy arn"
  value       = module.default_linux_appstack_ex.dereg_lambda_iam_policy_arn
}

output "default_linux_appstack_ex_dereg_event_rule_name" {
  description = "ASG Deregistration Event Rule name"
  value       = module.default_linux_appstack_ex.dereg_event_rule_name
}

output "default_linux_appstack_ex_dereg_event_rule" {
  description = "ASG Deregistration Event Rule arn"
  value       = module.default_linux_appstack_ex.dereg_event_rule_arn
}

###########################
# code deploy application #
###########################
output "default_linux_appstack_ex_code_deploy_application_id" {
  description = "Amazon's assigned ID for the application."
  value       = module.default_linux_appstack_ex.code_deploy_application_id
}

output "default_linux_appstack_ex_code_deploy_application_name" {
  description = "The application's name."
  value       = module.default_linux_appstack_ex.code_deploy_application_name
}

#############################
# code deploy group inplace #
#############################
output "default_linux_appstack_ex_inplace_code_deploy_group_id" {
  description = "The ID of the codedeploy deployment group"
  value       = module.default_linux_appstack_ex.inplace_code_deploy_group_id
}

