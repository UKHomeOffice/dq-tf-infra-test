module "apps" {
  source = "github.com/UKHomeOffice/dq-tf-apps-test"

  providers = {
    aws = "aws.APPS"
  }

  cidr_block                      = "10.1.0.0/16"
  public_subnet_cidr_block        = "10.1.0.0/24"
  ad_subnet_cidr_block            = "10.1.16.0/24"
  az                              = "eu-west-2a"
  az2                             = "eu-west-2b"
  #adminpassword                   = "${data.aws_kms_secret.ad_admin_password.ad_admin_password}"
  ad_aws_ssm_document_name        = "${module.ad.ad_aws_ssm_document_name}"
  #ad_writer_instance_profile_name = "${module.ad.ad_writer_instance_profile_name}"
  naming_suffix                   = "${local.naming_suffix}"

  s3_bucket_name = {
    archive_log                = "s3-dq-log-archive-bucket-${var.NAMESPACE}"
    archive_data               = "s3-dq-data-archive-bucket-${var.NAMESPACE}"
    working_data               = "s3-dq-data-working-bucket-${var.NAMESPACE}"
    landing_data               = "s3-dq-data-landing-bucket-${var.NAMESPACE}"
    oag_archive                = "s3-dq-oag-archive-${var.NAMESPACE}"
    acl_archive                = "s3-dq-acl-archive-${var.NAMESPACE}"
    reference_data             = "dq-reference-data-${var.NAMESPACE}"
    reference_data_archive     = "dq-reference-data-archive-${var.NAMESPACE}"
    reference_data_internal    = "dq-reference-data-internal-${var.NAMESPACE}"
    api_archive                = "s3-dq-api-archive-${var.NAMESPACE}"
    airports_archive           = "s3-dq-airports-archive-${var.NAMESPACE}"
    oag_internal               = "s3-dq-oag-internal-${var.NAMESPACE}"
    oag_transform              = "s3-dq-oag-transform-${var.NAMESPACE}"
    acl_internal               = "s3-dq-acl-internal-${var.NAMESPACE}"
    api_internal               = "s3-dq-api-internal-${var.NAMESPACE}"
    airports_internal          = "s3-dq-airports-internal-${var.NAMESPACE}"
    consolidated_schedule      = "s3-dq-consolidated-schedule-${var.NAMESPACE}"
    api_record_level_scoring   = "s3-dq-api-record-level-scoring-${var.NAMESPACE}"
    raw_file_retrieval_index   = "s3-dq-raw-file-retrieval-index-${var.NAMESPACE}"
    cross_record_scored        = "s3-dq-cross-record-scored-${var.NAMESPACE}"
    drt_working                = "s3-dq-drt-working-${var.NAMESPACE}"
    fms_working                = "s3-dq-fms-working-${var.NAMESPACE}"
    airports_working           = "s3-dq-airports-working-${var.NAMESPACE}"
    reporting_internal_working = "s3-dq-reporting-internal-working-${var.NAMESPACE}"
    carrier_portal_working     = "s3-dq-carrier-portal-working-${var.NAMESPACE}"
  }

  s3_bucket_acl = {
    archive_log                = "log-delivery-write"
    archive_data               = "private"
    working_data               = "private"
    landing_data               = "private"
    oag_archive                = "private"
    acl_archive                = "private" 
    reference_data             = "private"
    reference_data_archive     = "private"
    reference_data_internal    = "private"
    api_archive                = "private"
    airports_archive           = "private"
    oag_internal               = "private"
    oag_transform              = "private"
    acl_internal               = "private"
    api_internal               = "private"
    airports_internal          = "private"
    consolidated_schedule      = "private"
    api_record_level_scoring   = "private"
    raw_file_retrieval_index   = "private"
    cross_record_scored        = "private"
    drt_working                = "private"
    fms_working                = "private"
    airports_working           = "private"
    reporting_internal_working = "private"
    carrier_portal_working     = "private"
  }

  vpc_peering_connection_ids = {
    peering_to_peering = "${aws_vpc_peering_connection.peering_to_apps.id}"
    peering_to_ops     = "${aws_vpc_peering_connection.apps_to_ops.id}"
  }

  route_table_cidr_blocks = {
    peering_cidr = "${module.peering.peeringvpc_cidr_block}"
    ops_cidr     = "${module.ops.opsvpc_cidr_block}"
  }

  ad_sg_cidr_ingress = [
    "${module.peering.peeringvpc_cidr_block}",
    "${module.ops.opsvpc_cidr_block}",
    "${module.ad.cidr_block}",
    "10.1.0.0/16",
  ]

  pipeline_count = "${var.pipeline_count}"
}
