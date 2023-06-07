resource "aws_ecr_repository" "cohere" {
    name = var.ecr_repository_name
}

output "ecr_url" {
  value = aws_ecr_repository.cohere.repository_url
}

