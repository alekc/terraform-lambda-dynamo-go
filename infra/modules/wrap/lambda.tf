data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../bin/qtd"
  output_path = "bin/qtd.zip"
}
#
# For now do not implement dead letter queue mechanism

resource "aws_lambda_function" "func" {
  #checkov:skip=CKV_AWS_272:We do not require code-signing at the moment.
  #checkov:skip=CKV_AWS_116:Do not set up dead letter queue
  filename                       = data.archive_file.lambda_zip.output_path
  function_name                  = local.name
  role                           = aws_iam_role.lambda.arn
  handler                        = local.lambda_handler
  source_code_hash               = filebase64sha256(data.archive_file.lambda_zip.output_path)
  runtime                        = "go1.x"
  memory_size                    = 512
  timeout                        = 30
  reserved_concurrent_executions = 10 # POC limit

  # improves an issue where you cannot delete a security group because it's in use by a random ENI
  # see https://github.com/hashicorp/terraform-provider-aws/issues/10329#issuecomment-1425914496
  replace_security_groups_on_destroy = var.deploy_to_vpc ? true : false
  replacement_security_group_ids     = var.deploy_to_vpc ? [module.vpc[0].default_security_group_id] : []

  kms_key_arn = aws_kms_key.encryptor.arn # see https://docs.bridgecrew.io/docs/bc_aws_serverless_5

  environment {
    variables = {
      DYNAMO_QTD_TABLE = aws_dynamodb_table.main.name
      LOG_LEVEL        = var.lambda_log_level
    }
  }
  tracing_config {
    mode = "Active"
  }
  dynamic "vpc_config" {
    for_each = var.deploy_to_vpc ? [1] : []
    content {
      subnet_ids = module.vpc[0].private_subnets
      security_group_ids = [
        aws_security_group.lambda[0].id
      ]
    }
  }
}
