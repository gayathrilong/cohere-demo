variable "region" { default = "us-east-1" }
variable "vpc_name" {default = "cohere-example" }
variable "public_subnet_a_name" {default = "cohere-example-public-a" }
variable "public_subnet_b_name" {default = "cohere-example-public-b" }
variable "private_subnet_a_name" {default = "cohere-example-private-a" }  
variable "private_subnet_b_name" {default = "cohere-example-private-b" }
variable "ecr_repository_name" {default = "gayathri-cohere-demo"}