#---------------------------------------------------------#
#                           VPC                           #
#---------------------------------------------------------#

resource "aws_vpc" "wordpress-vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "wordpress-vpc"
  }
}
#---------------------------------------------------------#
#                           Subnets                       #
#---------------------------------------------------------#

resource "aws_subnet" "subnet" {
  count = length(var.subnet-name)
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = var.cidr_blocks[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.az[count.index]

  tags = {
    Name = var.subnet-name[count.index]
  }
}
#---------------------------------------------------------#
#              RT/RT_association, IGW, NAT                #
#---------------------------------------------------------#

resource "aws_route_table" "wordpess-rt_public" {
  vpc_id = aws_vpc.wordpress-vpc.id

  tags = {
    Name = "wordpess-rt_public"
  }
}
resource "aws_route_table" "wordpess-rt_nat" {
  vpc_id = aws_vpc.wordpress-vpc.id

  tags = {
    Name = "wordpess-rt_nat"
  }
}

resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.wordpess-rt_public.id
  destination_cidr_block = var.igw_cidr_block
  gateway_id             = aws_internet_gateway.wordpress_igw.id
}

resource "aws_route" "internet_gateway_route-0" {
  route_table_id         = aws_route_table.wordpess-rt_nat.id
  destination_cidr_block = var.igw_cidr_block
  gateway_id             = aws_nat_gateway.nat_gateway.id
}

#------------> Route Tables for Public Subnets <----------#

resource "aws_route_table_association" "subnet_association_pub-3" {
  subnet_id = aws_subnet.subnet[3].id        
  route_table_id = aws_route_table.wordpess-rt_public.id
}
resource "aws_route_table_association" "subnet_association_pub-4" {
  subnet_id = aws_subnet.subnet[4].id
  route_table_id = aws_route_table.wordpess-rt_public.id
}
resource "aws_route_table_association" "subnet_association_pub-5" {
  subnet_id = aws_subnet.subnet[5].id
  route_table_id = aws_route_table.wordpess-rt_public.id
}

#------------> Route Table for Private Subnet <-----------#

resource "aws_route_table_association" "subnet_association_priv-0" {
  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.wordpess-rt_nat.id
}
resource "aws_route_table_association" "subnet_association_priv-1" {
  subnet_id      = aws_subnet.subnet[1].id
  route_table_id = aws_route_table.wordpess-rt_nat.id
}
resource "aws_route_table_association" "subnet_association_priv-2" {
  subnet_id      = aws_subnet.subnet[2].id
  route_table_id = aws_route_table.wordpess-rt_nat.id
}

#-------------------> Create an igw <---------------------#

resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = aws_vpc.wordpress-vpc.id
  tags = {
    Name = "wordpress_igw"
  }
}

#------------> Create NAT + rt assosiation + EIP <--------#

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "NATGatewayEIP"
  }
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet[3].id

  tags = {
    Name = "NATGateway"
  }
}
#---------------------------------------------------------#
#                           Key-pair                      #
#---------------------------------------------------------#

resource "aws_key_pair" "key_pem" {
  key_name   = "key_pem"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair"
}
