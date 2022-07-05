# CodeBuild IAM role (one per project)
resource "aws_iam_role" "role" {
  name = "codebuild-role-${var.app_name}-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_full_access" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}


# CodeBuild IAM policy (one per project)
resource "aws_iam_role_policy" "role_policy" {
  role = aws_iam_role.role.name
  name = "codebuild-policy-${var.app_name}-${var.environment}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:PassRole",
        "iam:ListInstanceProfilesForRole",
        "iam:ListRolePolicies"
      ],
      "Resource": "arn:aws:iam::*:role/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:*",
        "ecs:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:*"
      ],
      "Resource": "arn:aws:secretsmanager:${var.region}:*:secret:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:*"       
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
      ],
      "Resource": "arn:aws:ssm:${var.region}:*:parameter*"
    },
    {
      "Effect": "Allow",
      "Action" : [
        "dynamodb:*" 
      ],
      "Resource": "*" 
    }
  ]
}
POLICY
}
