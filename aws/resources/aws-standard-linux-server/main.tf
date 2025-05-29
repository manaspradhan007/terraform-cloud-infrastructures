locals {
  sg_ids = split(
    ",",
    var.create_security_group ? join(",", aws_security_group.this.*.id) : join(",", var.sg_ids),
  )
  #instance_profile_name = var.execute_microservice && var.instance_profile_name != "" ? var.instance_profile_name : module.server-iam-role.iam_role_instance_profile_name
  execute_custom_script = var.custom_script_s3_bucket_name != "" && var.custom_script_s3_bucket_key != "" ? "yes" : "no"
  Ebs_volume_attached = var.execute_microservice ? data.aws_instance.attached_volumes[*].ebs_block_device : []
  Root_volume_attached = var.execute_microservice ? data.aws_instance.attached_volumes[*].root_block_device : []
}

##################
# Security Group #
##################
data "aws_subnet" "input" {
  id = var.subnet_id
}

data "aws_instance" "attached_volumes" {
  count        = var.execute_microservice ? 1 : 0
  depends_on = [aws_volume_attachment.ebs_att]
  instance_id = local.execute_custom_script == "yes" ? aws_instance.with_customscript[0].id : aws_instance.without_customscript[0].id
}



resource "aws_security_group" "this" {
  count = var.execute_microservice && var.create_security_group ? 1 : 0

  name = format("%s-%s", var.resource_name_prefix, "LINUX-SERVER-SG")
  description = format(
    "Auto-generated Security Group for %s-%s",
    var.resource_name_prefix,
    "LINUX-SERVER",
  )
  vpc_id = data.aws_subnet.input.vpc_id
  tags = merge(
     {
       "Name" = format("%s-%s", var.resource_name_prefix, "LINUX-SERVER-SG")
     },
     var.tags,
     var.instance_tags
   )

  ingress {
    description = "CSE Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.253.32.0/20", "10.253.68.147/32","10.253.68.144/32"]
  }

  ingress {
    description = "<company-name> Whitelist"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["159.127.199.0/24", "159.127.8.0/24", "159.127.66.0/24", "63.158.191.114/32", "208.46.64.130/32", "12.158.89.4/32", "12.106.189.0/24", "52.204.95.24/32", "52.203.83.66/32", "159.127.207.254/32", "159.127.85.254/32" , "10.226.10.0/24", "10.226.11.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



#######################################
#  Template Data for Userdata Scripts #
#######################################
data "template_file" "awscli" {
  template = file(
    "${path.module}/files/userdata/user_data_configure_aws_cli.sh",
  )

  vars = {
    tenant_code = var.tenant_code
    host_name   = var.host_name
    region      = var.region
    install_rapid7 = var.install_rapid7
  }
}

data "template_file" "trendmicro" {
  template = file(
    "${path.module}/files/userdata/user_data_configure_trend_micro.sh",
  )

  vars = {
    tenant_trend_api_url            = var.tenant_trend_api_url
    tenant_trend_api_username       = var.tenant_trend_api_username
    tenant_trend_api_password       = var.tenant_trend_api_password
    tenant_trend_api_auth_secret    = var.tenant_trend_api_auth_secret
    tenant_trend_cloud_account_name = var.tenant_trend_cloud_account_name
  }
}


data "template_file" "SentinelOne" {
  template = file(
    "${path.module}/files/userdata/user_data_install_Sentinel.sh",
  )
}

data "template_file" "filebeat" {
  template = file(
    "${path.module}/files/userdata/user_data_configure_filebeat.sh",
  )

  vars = {
    tenant_code       = lower(var.tenant_code)
    platform  = "linux"
    beat_type  = "filebeat"
    kafka_elb_endpoint  = var.kafka_elb_endpoint
    tenant_kafka_beat_topic = format("%s-%s","oslogs",lower(var.tenant_code))

  }
}

data "template_file" "metricbeat" {
  template = file(
    "${path.module}/files/userdata/user_data_configure_metricbeat.sh",
  )

  vars = {
    tenant_code       = lower(var.tenant_code)
    platform  = "linux"
    beat_type  = "metricbeat"
    kafka_elb_endpoint  = var.kafka_elb_endpoint
    tenant_kafka_beat_topic = format("%s-%s","metricbeat",lower(var.tenant_code))

  }
}

data "template_file" "vas" {
  template = file("${path.module}/files/userdata/user_data_configure_vas.sh")

  vars = {
    client_code                 = var.client_code
    tenant_environment          = var.tenant_environment
    tenant_environment_sequence = var.tenant_environment_sequence
    tenant_vas_username         = var.tenant_vas_username
    tenant_vas_password         = var.tenant_vas_password
    master_tenant_environment   = var.master_tenant_environment
  }
}

data "template_file" "opsramp" {
  template = file(
    "${path.module}/files/userdata/user_data_configure_opsramp.sh",
  )

  vars = {
    client_code = var.client_code
  }
}

data "template_file" "sumologic" {
  template = file(
    "${path.module}/files/userdata/user_data_install_sumologic.sh",
  )

  vars = {
    client_code          = lower(var.client_code)
    sumo_logic_secret_id = var.tenant_sumo_logic_secret_id
    tenant_environment   = lower(var.tenant_environment)
  }
}

data "template_file" "snowagent" {
  template = file(
    "${path.module}/files/userdata/user_data_install_snowagent.sh",
  )
}

data "aws_s3_bucket_object" "customscript" {
  count = local.execute_custom_script == "yes" ? 1 : 0

  bucket = lower(var.custom_script_s3_bucket_name)
  key    = var.custom_script_s3_bucket_key
}

##########################################
#  CloudInit Config for Userdata Scripts #
##########################################
data "template_cloudinit_config" "userdata_init" {
  count = local.execute_custom_script == "no" ? 1 : 0

  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.awscli.rendered
  }
 
  part {
    content_type = "text/x-shellscript"
    content      = var.install_sentinelone == true ? data.template_file.SentinelOne.rendered : data.template_file.trendmicro.rendered

  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.filebeat.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.metricbeat.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.opsramp.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.sumologic.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.snowagent.rendered
  }
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.vas.rendered
  }
}

data "template_cloudinit_config" "userdata_with_customscript_init" {
  count = local.execute_custom_script == "yes" ? 1 : 0

  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = var.install_sentinelone == true ? data.template_file.SentinelOne.rendered : data.template_file.trendmicro.rendered

  }


  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.awscli.rendered
  }


  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.filebeat.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.metricbeat.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.opsramp.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.sumologic.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.snowagent.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.aws_s3_bucket_object.customscript[0].body
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.vas.rendered
  }
}

#############
#  Instance #
#############
resource "aws_instance" "without_customscript" {
  count = var.execute_microservice && local.execute_custom_script == "no" ? 1 : 0

  subnet_id = var.subnet_id
  ami       = var.ami_id
  vpc_security_group_ids      = local.sg_ids
  iam_instance_profile        = var.instance_profile_name
  key_name                    = var.key_name
  instance_type               = var.instance_type
  monitoring                  = var.enable_monitoring
  disable_api_termination     = var.disable_api_termination
  associate_public_ip_address = var.associate_public_ip_address
  tags = merge(var.tags, var.instance_tags)

  provisioner "file" {
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.root}/${var.key_name}.pem")
      agent       = false
    }

    source      = "${path.module}/files/userdata/sources.json"
    destination = "/home/ec2-user/sources.json"
  }

  provisioner "file" {
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.root}/${var.key_name}.pem")
      agent       = false
    }

    source      = "${path.module}/files/userdata/configure_trend_agent.sh"
    destination = "/home/ec2-user/configure_trend_agent.sh"
  }

  provisioner "file" {
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.root}/${var.key_name}.pem")
      agent       = false
    }

    source      = "${path.module}/files/userdata/filebeat.yml.original"
    destination = "/home/ec2-user/filebeat.yml.original"
  }

  provisioner "file" {
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.root}/${var.key_name}.pem")
      agent       = false
    }

    source      = "${path.module}/files/userdata/metricbeat.yml.original"
    destination = "/home/ec2-user/metricbeat.yml.original"
  }

  user_data = data.template_cloudinit_config.userdata_init[0].rendered
}

resource "aws_instance" "with_customscript" {
  count = var.execute_microservice && local.execute_custom_script == "yes" ? 1 : 0

  subnet_id = var.subnet_id
  ami       = var.ami_id
  vpc_security_group_ids      = local.sg_ids
  iam_instance_profile        = var.instance_profile_name
  key_name                    = var.key_name
  instance_type               = var.instance_type
  monitoring                  = var.enable_monitoring
  disable_api_termination     = var.disable_api_termination
  associate_public_ip_address = var.associate_public_ip_address
  tags = merge(var.tags, var.instance_tags)
    
  provisioner "file" {
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.root}/${var.key_name}.pem")
      agent       = false
    }

    source      = "${path.module}/files/userdata/sources.json"
    destination = "/home/ec2-user/sources.json"
  }

  provisioner "file" {
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.root}/${var.key_name}.pem")
      agent       = false
    }

    source      = "${path.module}/files/userdata/configure_trend_agent.sh"
    destination = "/home/ec2-user/configure_trend_agent.sh"
  }

  provisioner "file" {
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.root}/${var.key_name}.pem")
      agent       = false
    }

    source      = "${path.module}/files/userdata/filebeat.yml.original"
    destination = "/home/ec2-user/filebeat.yml.original"
  }

  provisioner "file" {
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.root}/${var.key_name}.pem")
      agent       = false
    }

    source      = "${path.module}/files/userdata/metricbeat.yml.original"
    destination = "/home/ec2-user/metricbeat.yml.original"
  }

  user_data = data.template_cloudinit_config.userdata_with_customscript_init[0].rendered
}

resource "aws_ebs_volume" "example" {
  count = var.execute_microservice && length(var.ebs_volumes) > 0 ? length(var.ebs_volumes) : 0
  availability_zone = local.execute_custom_script == "yes" ? aws_instance.with_customscript[0].availability_zone : aws_instance.without_customscript[0].availability_zone
  size              = lookup(var.ebs_volumes[count.index], "volume_size", null)
  encrypted = lookup(var.ebs_volumes[count.index], "encrypted", null)
  iops = lookup(var.ebs_volumes[count.index], "iops", null)
  type = lookup(var.ebs_volumes[count.index], "volume_type", null)
  multi_attach_enabled = lookup(var.ebs_volumes[count.index], "multi_attach_enabled", null)
  snapshot_id = lookup(var.ebs_volumes[count.index], "snapshot_id", null)
  outpost_arn = lookup(var.ebs_volumes[count.index], "outpost_arn", null)
  kms_key_id = lookup(var.ebs_volumes[count.index], "kms_key_id", null)
} 

resource "aws_volume_attachment" "ebs_att" {
  count = var.execute_microservice && length(var.ebs_volumes) > 0 ? length(var.ebs_volumes) : 0
  depends_on = [aws_ebs_volume.example]
  device_name = var.device_names[count.index]
  volume_id   = aws_ebs_volume.example[count.index].id
  instance_id = local.execute_custom_script == "yes" ? aws_instance.with_customscript[0].id : aws_instance.without_customscript[0].id
  force_detach = lookup(var.ebs_volumes[count.index], "force_detach", null)
  skip_destroy = lookup(var.ebs_volumes[count.index], "skip_destroy", null)
}



