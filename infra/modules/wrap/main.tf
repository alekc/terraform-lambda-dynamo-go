locals {
  account_id     = data.aws_caller_identity.current.account_id
  lambda_handler = "qtd"
  name           = "dynamo-lambda-poc"
}

