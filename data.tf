data "aws_vpc_peering_connection" "ad_peering_with_ops" {
  provider      = aws.APPS
  vpc_id        = module.ops.opsvpc_id
  owner_id      = data.aws_caller_identity.apps.account_id
  peer_vpc_id   = module.ad.vpc_id
  peer_owner_id = data.aws_caller_identity.apps.account_id
}

data "aws_vpc_peering_connection" "ad_peering" {
  provider      = aws.APPS
  vpc_id        = module.apps.appsvpc_id
  owner_id      = data.aws_caller_identity.apps.account_id
  peer_vpc_id   = module.ad.vpc_id
  peer_owner_id = data.aws_caller_identity.apps.account_id
}

# data "aws_vpc_peering_connection" "ops_to_acpvpn" {
#   provider = "aws.APPS"
#
#   tags {
#     Name = "ops-to-vpn"
#   }
# }
#
# data "aws_vpc_peering_connection" "peering_to_acp" {
#   provider = "aws.APPS"
#
#   tags {
#     Name = "peering-to-acp"
#   }
# }

data "aws_caller_identity" "apps" {
  provider = aws.APPS
}

data "aws_caller_identity" "ci" {
  provider = aws.CI
}

data "aws_kms_secrets" "ad_joiner_password" {
  secret {
    name    = "ad_joiner_password"
    payload = "AQICAHjC4CKFKTYsLki4xGd1rSMF7wMNMTmrxkezpb60vXSGtwGe2oPXUcDg/4HPEaxPaLuuAAAAcDBuBgkqhkiG9w0BBwagYTBfAgEAMFoGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMeCVXGJ7AUltYlqFRAgEQgC3NtnY3hGkL4qbo4aGyjYLrHODz+BCUUubQ5oC3PyiyJcL0z+7auFvAFAnMJzc="

    context = {
      terraform = "active_directory"
    }
  }
}

data "aws_kms_secrets" "ad_admin_password" {
  secret {
    name    = "ad_admin_password"
    payload = "AQICAHjC4CKFKTYsLki4xGd1rSMF7wMNMTmrxkezpb60vXSGtwGe2oPXUcDg/4HPEaxPaLuuAAAAcDBuBgkqhkiG9w0BBwagYTBfAgEAMFoGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMeCVXGJ7AUltYlqFRAgEQgC3NtnY3hGkL4qbo4aGyjYLrHODz+BCUUubQ5oC3PyiyJcL0z+7auFvAFAnMJzc="

    context = {
      terraform = "active_directory"
    }
  }
}

data "aws_iam_policy" "write_to_cw" {
  arn = aws_iam_policy.write_to_cw.arn
}

resource "aws_iam_role" "test_role" {
  name               = "testing-write_to_cw"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
                    "ec2.amazonaws.com",
                    "s3.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "test_role" {
  role       = data.aws_iam_policy.write_to_cw.id
  policy_arn = aws_iam_policy.write_to_cw.id
}
