provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "ap-southeast-2"
}

resource "aws_iam_user" "kunal" {
  name = "Kunal"
}

resource "aws_iam_user" "matt" {
  name = "Matt"
}

resource "aws_iam_user" "donna" {
  name = "Donna"
}

resource "aws_iam_group" "dev" {
  name = "Dev"
}

resource "aws_iam_group_membership" "dev_membership" {
  name = "Dev Membership"

  users = [
    "${aws_iam_user.matt.name}",
    "${aws_iam_user.kunal.name}",
    "${aws_iam_user.donna.name}"
  ]

  group = "${aws_iam_group.dev.name}"
}

/* Individual user policy
resource "aws_iam_user_policy" "matt_s3_fullaccess" {
  name = "AmazonS3FullAccess"
  user = "${aws_iam_user.matt.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}
*/

resource "aws_iam_group_policy" "dev_s3_fullaccess" {
  name = "AmazonS3FullAccess"
  group = "${aws_iam_group.dev.id}"

  /* S3 Full Access policy */
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy" "dev_ec2_fullaccess" {
  name = "AmazonEC2FullAccess"
  group = "${aws_iam_group.dev.id}"

  /* EC2 Full Access policy */
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
{
      "Action": "ec2:*",
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "elasticloadbalancing:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "cloudwatch:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "autoscaling:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy" "dev_rds_fullaccess" {
  name = "AmazonRDSFullAccess"
  group = "${aws_iam_group.dev.id}"

  /* RDS Full Access policy */
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "rds:*",
        "cloudwatch:DescribeAlarms",
        "cloudwatch:GetMetricStatistics",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "sns:ListSubscriptions",
        "sns:ListTopics",
        "logs:DescribeLogStreams",
        "logs:GetLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ec2_s3_fullaccess" {
  name = "EC2-S3-Role"
  description = "IAM Role for EC2 to access S3"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }
]
}
EOF
}

resource "aws_iam_role_policy" "ec2_s3_fullaccess" {
  name = "EC2-S3-FullAccess"
  role = "${aws_iam_role.ec2_s3_fullaccess.id}"

  /* S3 Full Access policy */
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}
