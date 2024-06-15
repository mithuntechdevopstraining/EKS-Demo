vpc_cidr = "10.0.0.0/16"
environment = "Dev"
common_tags = {
    "Company"     = "Mithun Technologies"
    "ManagedBy"   = "IaC"
    "Environment" = "Development"
}
public_subnet_cidrs = ["10.0.0.0/19", "10.0.32.0/19"]
private_subnet_cidrs = ["10.0.96.0/19", "10.0.128.0/19"]
node_group_minsize = 1
node_group_maxsize = 3
nodegroup_instance_type = "t2.micro"
