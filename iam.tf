# resource "aws_iam_role_policy" "write_to_cw" {
#   role     = element(concat(module.ops.iam_roles, module.peering.iam_roles), count.index)
#   count    = 20
#   provider = "aws.APPS"
#
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "cloudwatch:PutMetricData",
#       "Effect": "Allow",
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents",
#         "logs:DescribeLogStreams"
#       ],
#         "Resource": [
#           "arn:aws:logs:*:*:*"
#       ]
#     },
#     {
#         "Effect": "Allow",
#         "Action": "ec2:DescribeTags",
#         "Resource": "*"
#     },
#     {
#       "Sid": "DomainJoinPolicy",
#       "Effect": "Allow",
#       "Action": [
#           "ssm:DescribeAssociation",
#           "ssm:ListAssociations",
#           "ssm:GetDocument",
#           "ssm:ListInstanceAssociations",
#           "ssm:UpdateAssociationStatus",
#           "ssm:UpdateInstanceAssociationStatus",
#           "ssm:UpdateInstanceInformation",
#           "ec2messages:AcknowledgeMessage",
#           "ec2messages:DeleteMessage",
#           "ec2messages:FailMessage",
#           "ec2messages:GetEndpoint",
#           "ec2messages:GetMessages",
#           "ec2messages:SendReply",
#           "ds:CreateComputer",
#           "ds:DescribeDirectories",
#           "ec2:DescribeInstanceStatus"
#       ],
#       "Resource": [
#           "*"
#       ]
#     }
#   ]
# }
# EOF
# }

resource "aws_iam_policy" "write_to_cw" {
  name     = "dq-tf-infra-write-to-cw"
  provider = aws.APPS

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "cloudwatch:PutMetricData",
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
        "Resource": [
          "arn:aws:logs:*:*:*"
      ]
    },
    {
        "Effect": "Allow",
        "Action": "ec2:DescribeTags",
        "Resource": "*"
    },
    {
      "Sid": "DomainJoinPolicy",
      "Effect": "Allow",
      "Action": [
          "ssm:DescribeAssociation",
          "ssm:ListAssociations",
          "ssm:GetDocument",
          "ssm:ListInstanceAssociations",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation",
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply",
          "ds:CreateComputer",
          "ds:DescribeDirectories",
          "ec2:DescribeInstanceStatus"
      ],
      "Resource": [
          "*"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_role" "test_role" {
  name               = "test_role"
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
  role       = aws_iam_role.test_role.id
  policy_arn = aws_iam_policy.write_to_cw.id
}
