output "ecr_registry" {
    value = aws_ecr_repository.server.repository_url
}