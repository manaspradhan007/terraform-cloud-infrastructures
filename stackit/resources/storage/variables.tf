
variable "project_id" {
  type = string
}

####################################
# Storage Variables
####################################

variable "storage_name" {
  type = string
}

variable "policy" {
  type = string
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "*"
    }
  ]
}
EOF
}