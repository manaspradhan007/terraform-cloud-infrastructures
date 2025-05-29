data "template_file" "cloudformation_sns_stack" {
  count    = var.execute_microservice && length(var.spot_notification_email_addresses) != 0 ? 1 : 0
  template = file("${path.module}/files/cf-templates/email-sns-stack.json.tpl")

  vars = {
    display_name = " SPOT NOTIFICATION"
    subscriptions = join(
      ",",
      formatlist(
        "{ \"Endpoint\": \"%s\", \"Protocol\": \"%s\"  }",
        var.spot_notification_email_addresses,
        "email",
      ),
    )
  }
}

resource "aws_cloudformation_stack" "cf_sns_topic" {
  count    = var.execute_microservice && length(var.spot_notification_email_addresses) != 0 ? 1 : 0
  name          = format("%s-%s", var.resource_name_prefix, "CF-SPOT-SNS-TOPIC")
  template_body = data.template_file.cloudformation_sns_stack[0].rendered

  tags = merge(
    {
      "Name" = format("%s-%s", var.resource_name_prefix, "CF-SPOT-SNS-TOPIC")
    },
    var.tags,
  )
}

resource "aws_cloudwatch_event_rule" "spot_rule" {
  count    = var.execute_microservice && length(var.spot_notification_email_addresses) != 0 ? 1 : 0
  
  name        = format("%s-%s", var.resource_name_prefix, "CW-SPOT-TERMINATION-RULE")
  description = "cloudwatch event rule for spot intance termination"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Spot Instance Interruption Warning"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "sns" {
  count    = var.execute_microservice && length(var.spot_notification_email_addresses) != 0 ? 1 : 0

  rule      = aws_cloudwatch_event_rule.spot_rule[0].name
  target_id = "SendToSNS"
  arn       = aws_cloudformation_stack.cf_sns_topic[0].outputs["ARN"]
}