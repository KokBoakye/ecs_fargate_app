output "alb_dns" {
  value = aws_lb.load_balancer.dns_name
}

output "aws_ecr_repo" {
  value = aws_ecr_repository.app_repo.repository_url
}
