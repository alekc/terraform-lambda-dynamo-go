resource "aws_dynamodb_table" "main" {
  name           = local.name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "ID"

  ##checkov:skip=CKV2_AWS_16:We do not need autoscaling for this POC
  attribute {
    name = "ID"
    type = "S"
  }
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.encryptor.arn
  }
  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_dynamodb_table_item" "qtd" {
  table_name = aws_dynamodb_table.main.name
  hash_key   = aws_dynamodb_table.main.hash_key

  item = <<ITEM
{
  "ID": {"S": "${uuid()}"},
  "text": {"S": "What you do today can improve all your tomorrows."}
}
ITEM
}
