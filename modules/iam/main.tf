resource "aws_iam_role" "eks_nodes" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = var.policy_arn
}

resource "aws_iam_instance_profile" "eks_nodes" {
  name = var.instance_profile_name
  role = aws_iam_role.eks_nodes.name
}
