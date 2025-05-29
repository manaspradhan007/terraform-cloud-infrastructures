resource "aws_iam_role" "cluster_role" {
   count = var.execute_microservice ? 1 :0
  
  name = format("%s-%s", var.resource_name_prefix, "CLUSTER-ROLE")

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_clusterpolicy_attachment" {
  count = var.execute_microservice ? 1 :0
  policy_arn = format("%s/%s","arn:aws:iam::aws:policy",var.eks_cluster_policy_name)
  role       = aws_iam_role.cluster_role[0].name
}

resource "aws_iam_role_policy_attachment" "eks_clusterservicepolicy_attachment" {
  count = var.execute_microservice ? 1 :0
  policy_arn = format("%s/%s","arn:aws:iam::aws:policy",var.eks_cluster_service_policy_name)
  role       = aws_iam_role.cluster_role[0].name
}
