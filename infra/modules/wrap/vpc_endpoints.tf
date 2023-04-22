data "aws_iam_policy_document" "vpc_endpoints" {
  # Potentially we could lock it down with the least privileges, but it would be outside of the scope for this exercise
  #checkov:skip=CKV_AWS_110:False positive, vpc endpoint doesn't permit privilege escalation
  #checkov:skip=CKV_AWS_1:False positive, vpc endpoint doesn't permit full permissions
  #checkov:skip=CKV_AWS_283:Vpc endpoint resource
  #checkov:skip=CKV_AWS_109:Vpc endpoint resource
  #checkov:skip=CKV_AWS_49:Vpc endpoint resource
  #checkov:skip=CKV_AWS_111:Vpc endpoint resource
  #checkov:skip=CKV_AWS_108:Vpc endpoint resource
  #checkov:skip=CKV_AWS_107:Vpc endpoint resource
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.private_route_table_ids
  policy            = data.aws_iam_policy_document.vpc_endpoints.json
}
