resource "aws_vpc" "cohere_vpc" {
    cidr_block = "192.168.0.0/22"
    tags = {
      Name = var.vpc_name
    }
}


resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.cohere_vpc.id

  ingress {
    protocol  = "TCP"
    self      = true
    from_port = 80
    to_port   = 80
  }
  ingress {
    protocol  = "TCP"
    self      = true
    from_port = 443
    to_port   = 443
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "public_coh_subnet_a" {
  vpc_id = aws_vpc.cohere_vpc.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = var.public_subnet_a_name
  }
}

resource "aws_subnet" "public_coh_subnet_b" {
  vpc_id = aws_vpc.cohere_vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = var.public_subnet_b_name
  }
}

resource "aws_subnet" "private_coh_subnet_a" {
  vpc_id = aws_vpc.cohere_vpc.id
  cidr_block = "192.168.2.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = var.private_subnet_a_name
  }
}

resource "aws_subnet" "private_coh_subnet_b" {
  vpc_id = aws_vpc.cohere_vpc.id
  cidr_block = "192.168.3.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = var.private_subnet_b_name
  }
}

resource "aws_internet_gateway" "cohere_gateway" {
    vpc_id = aws_vpc.cohere_vpc.id
}

resource "aws_eip" "eip_nat"{
    
}
resource "aws_nat_gateway" "nat_connection" {
  subnet_id = aws_subnet.public_coh_subnet_a.id
  allocation_id = aws_eip.eip_nat.id
}
resource "aws_route_table" "cohere_public" {
    vpc_id = aws_vpc.cohere_vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.cohere_gateway.id
    }
}
resource "aws_route_table" "cohere_private" {
    vpc_id = aws_vpc.cohere_vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_connection.id

    }  
}

resource "aws_route_table_association" "private_coh_assoc_a"{
    subnet_id = aws_subnet.private_coh_subnet_a.id
    route_table_id = aws_route_table.cohere_private.id
}

resource "aws_route_table_association" "private_coh_assoc_b"{
    subnet_id = aws_subnet.private_coh_subnet_b.id
    route_table_id = aws_route_table.cohere_private.id
}

resource "aws_route_table_association" "public_coh_assoc_a" {
    subnet_id = aws_subnet.public_coh_subnet_a.id
    route_table_id  = aws_route_table.cohere_public.id
  
}

resource "aws_route_table_association" "public_coh_assoc_b" {
    subnet_id = aws_subnet.public_coh_subnet_b.id
    route_table_id  = aws_route_table.cohere_public.id
  
}