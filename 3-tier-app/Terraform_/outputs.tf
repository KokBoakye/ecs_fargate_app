output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "db_endpoint" {
  value = aws_db_instance.mydb.endpoint
}
output "db_instance_id" {
  value = aws_db_instance.mydb.id
}

output "instance_public_ip_app" {
  description = "Public IP of the EC2 instance in the app tier"
  value       = aws_instance.app_server.public_ip
}