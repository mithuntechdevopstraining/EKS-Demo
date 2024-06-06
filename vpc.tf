resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = merge(var.common_tags,
    { "Name" : "${var.project_name}-${var.environment}-vpc" }
  )
}

resource "aws_subnet" "publicsubnets" {

  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.availability_zones.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags,
    {
      "Name" : "${var.project_name}-${var.environment}-vpc-publicsubnet-${count.index + 1}",
      "kubernetes.io/role/elb" : "1"
    }
  )
}


resource "aws_subnet" "privatesubnets" {

  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]

  tags = merge(var.common_tags,
    {
      "Name" : "${var.project_name}-${var.environment}-vpc-privatesubnet-${count.index + 1}",
      "kubernetes.io/role/internal-elb" : "1"
    }
  )

}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags,
    { "Name" : "${var.project_name}-${var.environment}-vpc-igw" }
  )
}

resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(var.common_tags,
    { "Name" : "${var.project_name}-${var.environment}-vpc-publicrt" }
  )
}

resource "aws_route_table_association" "publicrt_association" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.publicroute.id
  subnet_id      = aws_subnet.publicsubnets[count.index].id
}

resource "aws_eip" "eips" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"

  tags = merge(var.common_tags,
    { "Name" : "${var.project_name}-${var.environment}-vpc-eip-${count.index + 1}" }
  )

}

resource "aws_nat_gateway" "natgateways" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.eips[count.index].id
  subnet_id     = aws_subnet.publicsubnets[count.index].id

  tags = merge(var.common_tags,
    { "Name" : "${var.project_name}-${var.environment}-vpc-natgateway-${count.index + 1}" }
  )
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "privateroutes" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateways[count.index].id
  }

  tags = merge(var.common_tags,
    { "Name" : "${var.project_name}-${var.environment}-vpc-privateroute-${count.index + 1}" }
  )

}

resource "aws_route_table_association" "privateroutes_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.privatesubnets[count.index].id
  route_table_id = aws_route_table.privateroutes[count.index].id
}
