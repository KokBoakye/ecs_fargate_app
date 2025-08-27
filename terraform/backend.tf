terraform {
  backend "s3" {
    bucket       = "terraform-state-bucket-app-25-08-2025"
    use_lockfile = false
    region       = "eu-north-1"
    key          = "aws-terraform-states/terraform.tfstate"
    encrypt      = true
  }

}
