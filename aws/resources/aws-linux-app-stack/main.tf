locals {
  sg_ids                    = split(",",var.create_security_group ? join(",", aws_security_group.this.*.id) : join(",", var.sg_ids),)
  
  installcw                 = (length(var.memory_upscaling_alarm) != 0 && length(var.memory_downscaling_alarm) != 0) ? true : false
  codeDeployApplicationName = var.execute_microservice ? aws_codedeploy_app.this[0].name : ""
  codeDeployGroupName 		  = format("%s-%s", var.resource_name_prefix, "CD-GROUP")
  codePipelineName          = format("%s-%s", var.resource_name_prefix, "CP")
  instance_volumes          = concat(
    [{
      "device_name" = lookup(var.root_block_device, "device_name", null)
      "ebs" = {
        "delete_on_termination" = lookup(var.root_block_device, "delete_on_termination", null)
        "encrypted"             = lookup(var.root_block_device, "encrypted", null)
        "iops"                  = lookup(var.root_block_device, "iops", null)
        "volume_size"           = lookup(var.root_block_device, "volume_size", null)
        "volume_type"           = lookup(var.root_block_device, "volume_type", null)
      }
    }],
    var.block_device_mappings
  )
}

#zip the dereg Lambda code
resource "null_resource" "dereg_lambda_zip" {
  count = var.execute_microservice ? 1 : 0
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "sudo chmod -R 775 ${path.module}/files/zip_the_folder.sh"
  }

  provisioner "local-exec" {
    command = "${path.module}/files/zip_the_folder.sh \"${path.module}/files/dereg-lambda/\" deRegLambda.zip "
  }
}

#zip the Blue Green Lambda code
resource "null_resource" "blueGreenControl_lambda_zip" {
  count = var.execute_microservice ? 1 : 0
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "sudo chmod -R 775 ${path.module}/files/zip_the_folder.sh"
  }

  provisioner "local-exec" {
    command = "${path.module}/files/zip_the_folder.sh \"${path.module}/files/bluegreen/bluegreenASGControl-lambda/\" asgcontrolLambda.zip "
  }
}
resource "null_resource" "blueGreen_lambda_zip" {
  count = var.execute_microservice ? 1 : 0
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "sudo chmod -R 775 ${path.module}/files/zip_the_folder.sh"
  }

  provisioner "local-exec" {
    command = "${path.module}/files/zip_the_folder.sh \"${path.module}/files/bluegreen/bluegreen-lambda/\" bluegreenlambda.zip "
  }
}

###############################################
# Upload user-data scripts to tenant bucket #
###############################################

resource "null_resource" "upload_all_user_data" {
  count = var.execute_microservice ? 1 : 0
  provisioner "local-exec" {
    command = "export AWS_ACCESS_KEY_ID=\"${var.access_key}\" && export AWS_SECRET_ACCESS_KEY=\"${var.secret_key}\" && export AWS_SESSION_TOKEN=\"${var.token}\" && aws s3 cp ${path.module}/files/userdata/${var.os_flavour}/ s3://${var.artifacts_store_location}/${var.resource_name_prefix}/linux-app-stack/ --recursive --acl bucket-owner-full-control && unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN"
  }
  triggers = {
    RunAllTime = timestamp()
  }
}

######################################
# Template Data for Userdata Scripts  #
######################################
data "template_file" "awscli" {
  template = file(
    "${path.module}/files/userdata/${var.os_flavour}/user_data_configure_aws_cli.sh",
  )

  vars = {
    tenant_code                                   = var.tenant_code
    client_code                                   = var.client_code
    region                                        = var.region
    tenant_environment                            = var.tenant_environment
    bucket                                        = var.artifacts_store_location
    resource_name_prefix                          = var.resource_name_prefix
    install_rapid7                                = var.install_rapid7
    installcw                                     = local.installcw
    tenant_trend_api_url                          = var.tenant_trend_api_url
    tenant_trend_api_username                     = var.tenant_trend_api_username
    tenant_trend_api_password                     = var.tenant_trend_api_password
    tenant_trend_api_auth_secret                  = var.tenant_trend_api_auth_secret
    tenant_trend_cloud_account_name               = var.tenant_trend_cloud_account_name
    install_sentinelone                           = var.install_sentinelone
    kafka_elb_endpoint                            = var.kafka_elb_endpoint
    tenant_kafka_beat_topic                       = var.tenant_kafka_beat_topic
    tenant_kafka_configuration_version            = var.tenant_kafka_configuration_version
    tenant_kafka_metricbeat_topic                 = var.tenant_kafka_metricbeat_topic
    tenant_kafka_metricbeat_configuration_version = var.tenant_kafka_metricbeat_configuration_version
    tenant_environment_sequence                   = var.tenant_environment_sequence
    tenant_vas_username                           = var.tenant_vas_username
    tenant_vas_password                           = var.tenant_vas_password
    master_tenant_environment                     = var.master_tenant_environment
    resource_stack_vas_ou                         = var.resource_stack_vas_ou
    sumo_logic_secret_id                          = var.tenant_sumo_logic_secret_id
    tenant_s3_artifact_customscript               = var.tenant_s3_artifact_customscript
  }
}

#########################################
# Cloudinit Config for Userdata Scripts #
#########################################
data "template_cloudinit_config" "userdata_init" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.awscli.rendered
  }
}

##################
# Security group #
##################
resource "aws_security_group" "this" {
  count = var.execute_microservice && var.create_security_group ? 1 : 0

  name = format("%s-%s", var.resource_name_prefix, "ASG-SG")
  description = format(
    "Auto created default Security Group for %s-%s",
    var.resource_name_prefix,
    "ASG"
  )
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.default_asg_sg_ingress_rules
    content {

      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      description      = lookup(ingress.value, "description", null)
      from_port        = lookup(ingress.value, "from_port", null)
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", null)
      protocol         = lookup(ingress.value, "protocol", null)
      security_groups  = lookup(ingress.value, "security_groups", null)
      self             = lookup(ingress.value, "self", null)
      to_port          = lookup(ingress.value, "to_port", null)
    }
  }
  dynamic "egress" {
    for_each = var.default_asg_sg_egress_rules
    content {

      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      description      = lookup(egress.value, "description", null)
      from_port        = lookup(egress.value, "from_port", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", null)
      protocol         = lookup(egress.value, "protocol", null)
      security_groups  = lookup(egress.value, "security_groups", null)
      self             = lookup(egress.value, "self", null)
      to_port          = lookup(egress.value, "to_port", null)
    }
  }
  tags = merge(
    {
      "Name" = format("%s-%s", var.resource_name_prefix, "ASG-SG")
    },
    var.tags
  )
}

###################
# Launch Template #
###################
resource "aws_launch_template" "this" {
  count = var.execute_microservice ? 1 : 0

  name = format("%s-%s", var.resource_name_prefix, "LT")
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = local.sg_ids
  update_default_version = var.update_default_launch_template_version

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    name = var.service_instance_profile_name
  }


  dynamic "block_device_mappings" {
    for_each = local.instance_volumes
    content {
      device_name  = lookup(block_device_mappings.value, "device_name", null)
      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = flatten(list(lookup(block_device_mappings.value, "ebs", [])))
        content {
          delete_on_termination = lookup(ebs.value, "delete_on_termination", null)
          encrypted             = lookup(ebs.value, "encrypted", null)
          iops                  = lookup(ebs.value, "iops", null)
          kms_key_id            = lookup(ebs.value, "kms_key_id", null)
          snapshot_id           = lookup(ebs.value, "snapshot_id", null)
          volume_size           = lookup(ebs.value, "volume_size", null)
          volume_type           = lookup(ebs.value, "volume_type", null)
        }
      }
    }
  }
  user_data = base64encode(data.template_cloudinit_config.userdata_init.rendered)
}

########################
# Lambda for De-Reg Satellite #
########################

resource "aws_iam_role" "dereg_lambda_role" {
  count = var.execute_microservice ? 1 : 0
  name  = format("%s-%s", var.resource_name_prefix, "ASGDeReg-Role")
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = var.tags
}

resource "aws_iam_policy" "dereg_lambda_policy" {
  depends_on = [aws_iam_role.dereg_lambda_role]
  count = var.execute_microservice ? 1 : 0
  name  = format("%s-%s", var.resource_name_prefix, "ASGDeReg-Policy")
  description = "A policy for Lambda services"


  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWS",
            "Effect": "Allow",
            "Action": [
                "logs:*",
                "autoscaling:*",
                "cloudwatch:*",
                "ssm:*",
                "lambda:*",
                "ec2:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "kms:Decrypt",
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "dereg_lambda_policy_attach" {
  depends_on = [aws_iam_policy.dereg_lambda_policy]
  count      = var.execute_microservice ? 1 : 0
  role       = "${aws_iam_role.dereg_lambda_role[0].name}"
  policy_arn = "${aws_iam_policy.dereg_lambda_policy[0].arn}"
}

resource "aws_ssm_document" "sat_ssmdoc" {
  count         = var.execute_microservice ? 1 : 0
  name          = format("%s-%s", var.resource_name_prefix, "ASGDeReg-Sat")
  document_type = "Command"
  tags          = var.tags
  content = <<DOC
  {
  "schemaVersion" : "2.2",
  "description" : "De-registering instances from Satellite server",
  "mainSteps" : [ {
    "action" : "aws:runShellScript",
    "name" : "Script",
    "inputs" : {
      "runCommand" : [ "sudo subscription-manager remove --all", "sudo subscription-manager unsubscribe --all", "sudo subscription-manager unregister", "sudo yum -y remove $(rpm -qa | grep katello-ca-consumer)" ]
    }
  } ]
}
DOC
}

resource "aws_lambda_function" "dereg_lambda" {
  
  depends_on = [null_resource.dereg_lambda_zip,aws_iam_role_policy_attachment.dereg_lambda_policy_attach, aws_ssm_document.sat_ssmdoc]

  count         = var.execute_microservice ? 1 : 0
  filename      = "${path.module}/files/dereg-lambda/deRegLambda.zip"
  function_name = format("%s-%s", var.resource_name_prefix, "ASGDeReg")
  role          = "${aws_iam_role.dereg_lambda_role[0].arn}"
  
  vpc_config {
      subnet_ids          = var.private_subnets
      security_group_ids  = ( var.asg_dereg_lambda_sg_ids == [] ? local.sg_ids : var.asg_dereg_lambda_sg_ids )
  }

  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.6"
  timeout       = 90
  environment {
    variables = {
      ssm_document_name = aws_ssm_document.sat_ssmdoc[0].name,
      region = var.region,
      tenant_id = var.tenant_code,
      master_tenant_environment = var.master_tenant_environment
    }
  }
  tags          = var.tags
}

#CLOUD WATCH EVENT FOR IN_PLACE ASG
resource "aws_cloudwatch_event_rule" "dereg_event_rule" {
  count       = var.execute_microservice ? 1 : 0
  name        = var.deployment_type == "IN_PLACE" ? format("%s-%s", var.resource_name_prefix, "ASGDeReg-Event") : format("%s-%s", var.resource_name_prefix, "DeReg-Event-For-ASG-A")
  description = "De-Registering ASG instances"
  
  event_pattern = <<PATTERN
{
  "detail-type": [
    "EC2 Instance-terminate Lifecycle Action"
  ],
  "source": [
    "aws.autoscaling"
  ],
  "detail": {
    "AutoScalingGroupName": [
      "${aws_autoscaling_group.this[0].name}"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "dereg_lambda_target" {
  depends_on = [aws_lambda_function.dereg_lambda]
  count     = var.execute_microservice ? 1 : 0
  rule      = aws_cloudwatch_event_rule.dereg_event_rule[0].name
  arn       = aws_lambda_function.dereg_lambda[0].arn
}

resource "aws_lambda_permission" "dereg_cloudwatch" {
  depends_on    = [aws_lambda_function.dereg_lambda]
  count         = var.execute_microservice ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.dereg_lambda[0].function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.dereg_event_rule[0].arn
}

#CLOUD WATCH EVENT FOR BLUE_GREEN ASG
resource "aws_cloudwatch_event_rule" "dereg_event_rule_b" {
  count       = var.execute_microservice && var.deployment_type == "BLUE_GREEN" ? 1 : 0
  name        = format("%s-%s", var.resource_name_prefix, "DeReg-Event-For-ASG-B")
  description = "De-Registering ASG instances"
  
  event_pattern = <<PATTERN
{
  "detail-type": [
    "EC2 Instance-terminate Lifecycle Action"
  ],
  "source": [
    "aws.autoscaling"
  ],
  "detail": {
    "AutoScalingGroupName": [
      "${local.asgTWO}"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "dereg_lambda_target_b" {
  count         = var.execute_microservice && var.deployment_type == "BLUE_GREEN" ? 1 : 0
  depends_on    = [aws_lambda_function.dereg_lambda]
  rule          = aws_cloudwatch_event_rule.dereg_event_rule_b[0].name
  arn           = aws_lambda_function.dereg_lambda[0].arn
}

resource "aws_lambda_permission" "dereg_cloudwatch_b" {
  
  count         = var.execute_microservice && var.deployment_type == "BLUE_GREEN" ? 1 : 0
  depends_on    = [aws_lambda_function.dereg_lambda]
  statement_id  = "AllowExecutionFromCloudWatchForASGB"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.dereg_lambda[0].function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.dereg_event_rule_b[0].arn
}


##############################
# Change Scripts Permission  #
##############################
resource "null_resource" "change_script_permission" {
  count = var.execute_microservice ? 1 : 0
  triggers = {
    run_all_time = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "sudo chmod -R 775 ${path.module}/files/bluegreen/"
  }
}

###############################
# Asg Update script Execution when changes in launch template #
###############################
resource "null_resource" "asg_update" {
  
  count                 = var.execute_microservice && var.recycle_asg ? 1 : 0
  triggers = {
    image_id                  = var.image_id
    launch_configuration      = element(concat(aws_launch_template.this.*.latest_version, list("")), 0)
  }
  
  depends_on = ["aws_autoscaling_group.this", "aws_launch_template.this"]
  provisioner "local-exec" {
    command = "sudo chmod -R 775 ${path.module}/files/ && ${path.module}/files/recycle_asg.sh  \"${var.access_key}\" \"${var.secret_key}\" \"${var.token}\" \"${var.region}\" \"${aws_autoscaling_group.this[0].name}\" \"${var.image_id}\" "
  }
}
