# VPC Config, Subnets, Endpoints, NAT

resource "aws_vpc" vpc {
  cidr_block = var.cidr-block
  tags = {
    Name = var.Name
    Billing = var.Billing-Tag,
    Environment = var.Environment-Tag
  }
}

resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.vpc.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.Availability-Zone, count.index)

 tags = {
   Name = "Public Subnet ${count.index + 1}",
   Billing = var.Billing-Tag,
   Environment = var.Environment-Tag
 }
}
 
resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.vpc.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.Availability-Zone, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}",
   Billing = var.Billing-Tag,
   Environment = var.Environment-Tag
 }
}

# internet routing
resource "aws_internet_gateway" "basic-igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = join("-", [var.Name], ["IGW"])
    Billing = var.Billing-Tag,
    Environment = var.Environment-Tag
 }
}

# public subnets routing

resource "aws_route_table" "basic-public-table" {
 vpc_id = aws_vpc.vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.basic-igw.id
 }
 
 tags = {
  Name = join("-", [var.Name], ["Public-Route-Table"])
  Billing = var.Billing-Tag
  Environment = var.Environment-Tag
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.basic-public-table.id
}

# private subnets routing

resource "aws_eip" "basic-eip" {

  tags = {
    Name = join("-", [var.Name], ["nat-gateway-eip"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_nat_gateway" "basic-nat-gw" {
  allocation_id = aws_eip.basic-eip.id
  subnet_id     = element(aws_subnet.public_subnets[*].id, 0)

  tags = {
    Name = join("-", [var.Name], ["NAT-Gateway"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_route_table" "basic-private-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.basic-nat-gw.id
  }

  tags = {
    Name = join("-", [var.Name], ["Private-Route-Table"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.basic-private-table.id
}

# VPC Endpoints

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

tags = {
    Name = join("-", [var.Name], ["S3-Gateway-Endpoint"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_security_group" "basic-default" {
  name        = "basic-default"
  description = "Allow all in and all out"
  vpc_id = aws_vpc.vpc.id

ingress { # Egress all allow
    description = "Ingress allow"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  }

egress { # Egress all allow
    description = "Egress allow"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = join("-", [var.Name], ["basic-default-sg"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_vpc_endpoint" "s3_interface" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.basic-default.id]

tags = {
    Name = join("-", [var.Name], ["S3-Interface-Endpoint"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.basic-default.id]

tags = {
    Name = join("-", [var.Name], ["SSM-Interface-Endpoint"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.basic-default.id]

tags = {
    Name = join("-", [var.Name], ["SSM-Messages-Interface-Endpoint"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.ec2"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.basic-default.id]

tags = {
    Name = join("-", [var.Name], ["EC2-Interface-Endpoint"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.basic-default.id]

tags = {
    Name = join("-", [var.Name], ["EC2-Messages-Interface Endpoint"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_vpc_endpoint" "kms" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.kms"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.basic-default.id]

tags = {
    Name = join("-", [var.Name], ["KMS-Interface-Endpoint"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.logs"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.basic-default.id]

tags = {
    Name = join("-", [var.Name], ["Logs-Interface-Endpoint"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}