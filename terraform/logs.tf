resource "aws_cloudwatch_log_group" "app" {
  name              = "${var.app_name}-${var.environment}"
  retention_in_days = var.log_retention_in_days

}
