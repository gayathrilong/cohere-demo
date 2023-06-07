resource "aws_security_group" "cohere_lb_sg" {
  name = "cohere_lb_allow"
  description = "allow traffic"
  vpc_id = data.aws_vpc.cohere_vpc.id
  ingress{
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}



resource "aws_security_group" "cohere_ecs_service_sg" {
  name = "cohere_ecs_service_allow"
  description = "allow traffic"
  vpc_id = data.aws_vpc.cohere_vpc.id
  ingress{
        from_port   = var.backend_port
        to_port     = var.backend_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}



