# Microservice Name
terraform-aws-eks-cluster
   
# Purpose
This microservice allows user to create a basic eks cluster along with the necessary iam roles, security groups and eks add ons. 

# Sprint detail
This version is being released as part of  Q2 Sprint 5 Year 2021.

# Changes included
This version of microservice includes this change.

- Added eks cluster creatiom
- Added iam role crtion required for eks cluster
- Added eks add on creation 

##  Changes in Inputs  
| Name                  | Description           | Type  | Default | Required |
| --------------------- |:---------------------:| -----:| -------:| --------:|
| execute_microservice      |  Main switch to control the execution of this microservice based on consumer logic. | bool | true | no       |
| resource_name_prefix      | name prefix. | string | none | yes  |
| tags      | tags to be associated with all the resources | map(string) | none | yes  |
| subnet_ids      | List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane. | list(string) | none | yes  |
| enable_cluster_endpoint_private_access | Whether the Amazon EKS private API server endpoint is enabled. | bool | true | no  |
| enable_cluster_endpoint_public_access  | Whether the Amazon EKS public  API server endpoint is enabled. | bool | false| no  |
| cluster_public_access_cidrs  | Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. | list(string) | [] ]| no  |
| kms_key_arn_for_cluster_encryption  | This provides envelope encryption of Kubernetes secrets stored in etcd for your cluster. This encryption is in addition to the EBS volume encryption that is enabled by default for all data (including secrets) that is stored in etcd as part of an EKS cluster. Once enabled, secrets encryption cannot be modified or removed. | string | ""  | no  |
| cluster_encryption_config_resources  | Cluster Encryption Config Resources to encrypt, e.g. ['secrets'] | string | []  | no  |
| enabled_cluster_log_types  | A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]. | list(string) | []  | no  |
| cluster_log_retention_period  | Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. | number | 7  | no  |
| eks_cluster_addons  | Every map in this list can contain 3 attributes. name, version and resolved conflicts. name - Name of the EKS add-on, The name must match one of the names returned by https://docs.aws.amazon.com/cli/latest/reference/eks/list-addons.html. version - The version of the EKS add-on. The version must match one of the versions returned by https://docs.aws.amazon.com/cli/latest/reference/eks/describe-addon-versions.html.Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE and OVERWRITE. NOTE: Amazon EKS add-on can only be used with Amazon EKS Clusters running version 1.18 with platform version eks.3 or later . | list(map(string)) | []  | no  |
| eks_cluster_policy_name | eks cluster service policy name | string | AmazonEKSClusterPolicy | no  |
| eks_cluster_service_policy_name | eks cluster service policy name | string | AmazonEKSServicePolicy | no  |
| cluster_default_sg_ingress_rules | List of ingress rule for cluster security group | list(any) | [
    {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["10.253.32.0/20"]
      description = "CSE Access"
    },
  ] | no  |
| cluster_default_sg_egress_rules | List of egress rule for default cluster security group | list(any) | [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ] | no  |
| cluster_security_groups | List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates to use to allow communication between your worker nodes and the Kubernetes control plane | list(string) | [] | no  |
| kubernetes_version | Kubernetes version. Defaults to EKS Cluster Kubernetes version. Terraform will only perform drift detection if a configuration value is provided | string | null | no  |

##  Changes in Outputs 
CloudFront references included in existing outputs.
- cluster_security_group_id
- cluster_security_group_arn
- cluster_security_group_name
- cluster_id
- cluster_arn
- cluster_endpoint
- cluster_kubernetes_version
- cluster_managed_security_group_id
- cluster_role_arn
- cluster_encryption_config_resources
- cluster_encryption_config_provider_key_arn
- cluster_add_on_details
##