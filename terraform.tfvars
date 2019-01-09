terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket = "dq-tf-infra-test-terraform-state"
      region = "eu-west-2"
      dynamodb_table = "terraform-test-state"
      key = "${get_env("TF_VAR_NAMESPACE", "test")}/terraform.tfstate"
      encrypt = true
    }
  }
}
