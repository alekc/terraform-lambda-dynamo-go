data "aws_iam_policy_document" "lambda_assume_role" {
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

# DynamoDb && KMS
data "aws_iam_policy_document" "dynamo" {
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

resource "aws_iam_policy" "dynamodb" {
  name_prefix = "${local.name}-dynamodb"
  policy      = data.aws_iam_policy_document.dynamo.json
}
resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.dynamodb.arn
}
