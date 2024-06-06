variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "project_name" {
  type    = string
  default = "MithunTech"
}

variable "environment" {
  type    = string
  default = "Dev"
}

variable "common_tags" {
  type = map(string)
  default = {
    "Company"     = "Mithun Technologies"
    "ManagedBy"   = "IaC"
    "Environment" = "Development"
  }
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]
}

variable "workerrole_policy_arns" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]
}

variable "node_group_minsize" {
  type    = number
  default = 1
}

variable "node_group_maxsize" {
  type    = number
  default = 10
}


variable "nodegroup_instance_type" {
  type    = string
  default = "t2.medium"
}