#############
# Providers #
#############

region     = "<insert region here>"
access_key = "<insert access key here>"
secret_key = "<insert Secret key here>"
token      = "<insert security here>"

execute_microservice = true
default_eks_example_resource_name_prefix = "D1KAR02"
default_eks_example_subnet_ids = ["subnet-0a74a146e1e37a0b1","subnet-037a9a3d2249b596a"]
default_eks_example_enable_cluster_endpoint_public_access = false
default_eks_example_enable_cluster_endpoint_private_access = true
default_eks_example_kms_key_arn_for_cluster_encryption = "arn:aws:kms:us-east-1:454125583165:key/6aa8c6a6-a69f-40d5-b7b6-bfdbf427c947"
default_eks_example_enabled_cluster_log_types = ["api","audit"]

default_eks_example_eks_cluster_addons = [ { name = "vpc-cni",version = "v1.7.5-eksbuild.2", resolve_conflicts = "NONE"},{ name = "kube-proxy",version = "v1.19.6-eksbuild.2", resolve_conflicts = "OVERWRITE"},{ name = "coredns"}]