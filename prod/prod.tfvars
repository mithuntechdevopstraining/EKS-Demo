vpc_cidr = "192.168.0.0/16"
environment = "Dev"
common_tags = {
    "Company"     = "Mithun Technologies"
    "ManagedBy"   = "IaC"
    "Environment" = "Production"
}
public_subnet_cidrs = ["192.168.0.0/19", "192.168.32.0/19","192.168.64.0/19"]
private_subnet_cidrs = ["92.168.96.0/19", "192.168.128.0/19","192.168.160.0/19"]
node_group_minsize = 10
node_group_maxsize = 50
nodegroup_instance_type = "t2.2xlarge"