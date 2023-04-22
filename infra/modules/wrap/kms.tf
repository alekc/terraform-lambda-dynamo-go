data "aws_iam_policy_document" "encryptor" {
  #checkov:skip=CKV_AWS_109:Allow wildcards
  #checkov:skip=CKV_AWS_111:Allow wildcards (write access)
  statement {
    sid = "Enable IAM User Permissions"
    actions = [
      "kms:*",
    ]
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    resources = ["*"]
  }
  statement {
    sid = "AllowCloudWatchLogs"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com",
      ]
    }
    resources = ["*"]
  }
}

resource "aws_kms_key" "encryptor" {
  description             = "This key is used to encrypt lambda poc logs & dynamodb data"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.encryptor.json
}
resource "aws_kms_alias" "encryptor" {
  name          = "alias/${local.name}"
  target_key_id = aws_kms_key.encryptor.key_id
}
