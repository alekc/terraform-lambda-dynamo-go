data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../bin/qtd"
  output_path = "bin/qtd.zip"
}

resource "aws_lambda_function" "func" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = local.name
  role             = aws_iam_role.lambda.arn
  handler          = local.lambda_handler
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
  runtime          = "go1.x"
  memory_size      = 512
  timeout          = 30

  environment {
    variables = {
      DYNAMO_QTD_TABLE = aws_dynamodb_table.main.name
    }
  }
}
