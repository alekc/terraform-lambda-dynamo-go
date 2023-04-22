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
data "aws_iam_policy_document" "logs" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${local.account_id}:log-group:/aws/lambda/${local.name}*:*"
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

# DynamoDbPolicy
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
      #      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.main.name}"
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
