remote_state {
  backend = "s3"
  config = {
    bucket = "terraform-statefiles-all-envs"
    region = "eu-west-2"
    dynamodb_table = "terraform-test-state"
    key = "dq-tf-infra/terraform-0.12/${get_env("TF_VAR_NAMESPACE", "test")}/infra-test-terraform-new.tfstate"
    encrypt = true
  }
}
