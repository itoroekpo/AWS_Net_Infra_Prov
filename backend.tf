terraform {
    backend "s3" {
        bucket = "itoro-s3-bucket"
        key = "state/terraform.tfstate"
        region = "us-east-1"
    }
}

# On terminal
# terraform init to configure s3 backend
# terraform workspace list --> to list the workspaces
# terraform workspace new Dev --> to create a new workspace

