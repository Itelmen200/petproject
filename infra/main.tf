terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
    token = var.GITHUB_TOKEN
}

terraform {
  backend "s3" {
    bucket = "petproject-terraform" 
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "github_repository_environment" "example" {
  environment  = terraform.workspace
  repository   = var.repository
}

resource "github_actions_environment_secret" "github_token" {
  repository        = var.repository
  environment       = github_repository_environment.example.environment
  secret_name       = "GH_TOKEN"
  plaintext_value   = var.GITHUB_TOKEN
}

resource "github_actions_environment_secret" "aws_access_key_id" {
  repository        = var.repository
  environment       = github_repository_environment.example.environment
  secret_name       = "AWS_ACCESS_KEY_ID"
  plaintext_value   = var.AWS_ACCESS_KEY_ID
}

resource "github_actions_environment_secret" "aws_secret_access_key" {
  repository        = var.repository
  environment       = github_repository_environment.example.environment
  secret_name       = "AWS_SECRET_ACCESS_KEY"
  plaintext_value   = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_ecr_repository" "server" {
  name                 = "server"
}

resource "github_actions_environment_secret" "repository_url" {
  repository        = var.repository
  environment       = github_repository_environment.example.environment
  secret_name       = "ECR_REPOSITORY"
  plaintext_value   = aws_ecr_repository.server.repository_url
}



