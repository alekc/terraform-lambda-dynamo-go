data "aws_iam_policy_document" "lambda_assume_role" {
  #checkov:skip=CKV_AWS_111::Allow write without constraints for POC purposes
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name_prefix        = local.name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Logs Policy
#tfsec:ignore:aws-iam-no-policy-wildcards false positive (we are limiting it to lambda name path)
data "aws_iam_policy_document" "logs" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]



    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.log.name}*:*"
    ]
  }
}

resource "aws_iam_policy" "logs" {
  name_prefix = "${local.name}-logs"
  policy      = data.aws_iam_policy_document.logs.json
}

resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.logs.arn
}

data "aws_iam_policy_document" "extra" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Scan"
    ]

    resources = [
      aws_dynamodb_table.main.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      aws_kms_key.encryptor.arn
    ]
  }
}

resource "aws_iam_policy" "extra" {
  name_prefix = "${local.name}-permissions"
  policy      = data.aws_iam_policy_document.extra.json
}
resource "aws_iam_role_policy_attachment" "extra" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.extra.arn
}

# VPC deployment
data "aws_iam_policy_document" "vpc_permissions" {
  count   = var.deploy_to_vpc ? 1 : 0
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:AttachNetworkInterface",
    ]
    #checkov:skip=CKV_AWS_111:False positive, we do limit by VPC
    #tfsec:ignore:aws-iam-no-policy-wildcards we do restrict by arn
    resources = ["*"]
    condition {
      test     = "ArnLikeIfExists"
      variable = "ec2:Vpc"
      values   = [module.vpc[0].vpc_arn]
    }
  }
}
resource "aws_iam_policy" "vpc_permissions" {
  count       = var.deploy_to_vpc ? 1 : 0
  name_prefix = "${local.name}-vpc"
  policy      = data.aws_iam_policy_document.vpc_permissions[0].json
}
resource "aws_iam_role_policy_attachment" "vpc_permissions" {
  count      = var.deploy_to_vpc ? 1 : 0
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.vpc_permissions[0].arn
}
