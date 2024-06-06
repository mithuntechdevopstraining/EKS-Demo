resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-${var.environment}-cluster"
  role_arn = aws_iam_role.clusterrole.arn
  version  = "1.30"

  vpc_config {

    subnet_ids              = flatten([aws_subnet.publicsubnets[*].id, aws_subnet.privatesubnets[*].id])
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

  }

  tags = merge(var.common_tags,
    {
      "Name" : "${var.project_name}-${var.environment}-cluster"
    }
  )

  depends_on = [aws_iam_role_policy_attachment.cluster_role_policy_attachment]


}


resource "aws_iam_role" "clusterrole" {
  name               = "${var.project_name}-${var.environment}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = merge(var.common_tags,
    {
      "Name" : "${var.project_name}-${var.environment}-eks-cluster-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "cluster_role_policy_attachment" {
  role       = aws_iam_role.clusterrole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-${var.environment}-cluster-node-group"
  node_role_arn   = aws_iam_role.workerrole.arn
  depends_on      = [aws_iam_role_policy_attachment.workerrole-policy-attachments]

  subnet_ids = aws_subnet.privatesubnets[*].id


  scaling_config {
    desired_size = var.node_group_minsize
    min_size     = var.node_group_minsize
    max_size     = var.node_group_maxsize
  }

  update_config {
    max_unavailable = 1
  }

  ami_type       = "AL2_x86_64"
  disk_size      = "20"
  capacity_type  = "ON_DEMAND"
  instance_types = [var.nodegroup_instance_type]

}

resource "aws_iam_role" "workerrole" {
  name               = "${var.project_name}-${var.environment}-eks-worker-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_nodes.json
  tags = merge(var.common_tags,
    {
      "Name" : "${var.project_name}-${var.environment}-eks-worker-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "workerrole-policy-attachments" {
  count      = length(var.workerrole_policy_arns)
  policy_arn = element(var.workerrole_policy_arns, count.index)
  role       = aws_iam_role.workerrole.name
}

