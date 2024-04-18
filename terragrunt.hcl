remote_state {
  backend = "s3"
  config = {
    bucket = "terraform-statefiles-all-envs"
    region = "eu-west-2"
    dynamodb_table = "terraform-test-state"
    key = "dq-tf-infra/terraform--1.5/${get_env("TF_VAR_NAMESPACE", "test")}/infra-test-terraform.tfstate"
    encrypt = true
  }
}
