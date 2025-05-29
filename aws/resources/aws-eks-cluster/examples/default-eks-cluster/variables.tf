##########
# Common #
##########
variable "execute_microservice" {
  description = "Main switch to control the execution of this microservice based on consumer logic."
  default     = true
}

variable "default_eks_example_resource_name_prefix" {
  description = "Name prefix to be used to derive names for all the resources."
  default     = ""
}

variable "default_eks_example_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}


###############
# eks cluster #
###############
variable "default_eks_example_subnet_ids" {
  description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
  default     = ""
}
variable "default_eks_example_enable_cluster_endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  default     = true
}
variable "default_eks_example_enable_cluster_endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  default     = false
}

variable "default_eks_example_cluster_public_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0."
}

variable "default_eks_example_kms_key_arn_for_cluster_encryption" {
  description = "This provides envelope encryption of Kubernetes secrets stored in etcd for your cluster. This encryption is in addition to the EBS volume encryption that is enabled by default for all data (including secrets) that is stored in etcd as part of an EKS cluster. Once enabled, secrets encryption cannot be modified or removed."
  default     = ""
}
variable "default_eks_example_cluster_encryption_config_resources" {
  type        = list(any)
  default     = ["secrets"]
  description = "Cluster Encryption Config Resources to encrypt, e.g. ['secrets']"
}

variable "default_eks_example_enabled_cluster_log_types" {
  type        = list(string)
  default     = []
  description = "A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]"
}
variable "default_eks_example_eks_cluster_addons" {
  type = list(map(string))
  default =[]
  description = "Every map in this list can contain 3 attributes. name, version and resolved conflicts. name - Name of the EKS add-on, The name must match one of the names returned by https://docs.aws.amazon.com/cli/latest/reference/eks/list-addons.html. version - The version of the EKS add-on. The version must match one of the versions returned by https://docs.aws.amazon.com/cli/latest/reference/eks/describe-addon-versions.html.Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE and OVERWRITE. NOTE: Amazon EKS add-on can only be used with Amazon EKS Clusters running version 1.18 with platform version eks.3 or later ."
}

variable "default_eks_example_cluster_default_sg_ingress_rules" {
  description = "List of ingress rule for cluster security group"
  type        = list(any)
  default = [
    {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["10.253.32.0/20"]
      description = "CSE Access"
    },
  ]
}
#########################
# eks cluster node group#
#########################
variable "default_eks_example_node_group_default_sg_ingress_rules" {
  description = "List of ingress rule for default node group security group"
  type        = list(any)
  default = [
    {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["10.253.32.0/20"]
      description = "CSE Access"
    },
  ]
}