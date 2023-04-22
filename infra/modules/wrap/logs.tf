locals {
  lambda_log_group_name = "/aws/lambda/${local.name}"
  apigw_group_name      = "/aws/api_gw/${aws_apigatewayv2_api.main.name}"
}
resource "aws_cloudwatch_log_group" "log" {
  name              = local.lambda_log_group_name
  retention_in_days = 1
  kms_key_id        = aws_kms_key.encryptor.arn
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = local.apigw_group_name

  retention_in_days = 1 # for the demo purposes, on actual deployment this is going to be higher
  kms_key_id        = aws_kms_key.encryptor.arn
}
