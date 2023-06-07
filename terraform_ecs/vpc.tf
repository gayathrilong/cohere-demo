data aws_vpc "cohere_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data aws_subnet "cohere_private_a" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_a_name]
  }
}

data aws_subnet "cohere_private_b" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_b_name]
  }
}

data aws_subnet "cohere_public_a" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_a_name]
  }
}

data aws_subnet "cohere_public_b" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_b_name]
  }
}