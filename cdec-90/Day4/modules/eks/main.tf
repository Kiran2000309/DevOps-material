resource "aws_iam_role" "eks_cluster_role" {
    name = "cbz-cluster-role"
    assume_role_policy = jsonencode({
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Principal": {
                   "Service": [
                       "eks.amazonaws.com"
                   ]
                },
                "Action": "sts:AssumeRole"
            }
        ]
   })
}


data "aws_vpc" "my_vpc" {
    default = true
}


data "aws_subnets" "my_subnets" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.my_vpc.id]
    }
    default = true
}


resource "aws_iam_role_policy_attachment" "cluster_policy_attachment" {
    role       = aws_iam_role.eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


resource "aws eks cluster" "my_cluster" {
    name     = "my-cluster"
    role_arn = aws_iam_role.eks_cluster_role.arn
     vpc_config {
        subnet_ids = data.aws_subnets.my_subnets.ids
    }

    depends_on = [
        aws_iam_role_policy_attachment.cluster_policy_attachment
    ]
}


resource "aws_iam_role" "node_role" {
    name = "cbz-node-role"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "sts:AssumeRole"
               ],
                "Principal": {
                    "Service": [
                        "ec2.amazonaws.com"
                    ]
                }
            }
        ]
    })
}


resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
    role       = aws_iam_role.node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role_policy_attachment" "eks_worker_policy_attachment" {
    role       = aws_iam_role.node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "container_registry_policy_attachment" {
    role       = aws_iam_role.node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
 

resource "aws_eks_node_group" "my_node_group" {
    cluster_name    = aws_eks_cluster.my_cluster.name
    node_group_name = "my-node-group"
    node_role_arn   = aws_iam_role.node_role.arn
    subnet_ids      = data.aws_subnets.my_subnets.ids

    scaling_config {
        desired_size = 2
        max_size     = 2
        min_size     = 2
    }

    update_config {
        max_unavailable = 1
    }

    depends_on = [
          aws_eks_cluster.my_cluster,
          aws_iam_role_policy_attachment.eks_cni_policy_attachment,
          aws_iam_role_policy_attachment.eks_worker_policy_attachment,
          aws_iam_role_policy_attachment.container_registry_policy_attachment
    ]
}