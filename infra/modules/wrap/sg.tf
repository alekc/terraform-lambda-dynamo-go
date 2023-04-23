resource "aws_security_group" "lambda" {
  count       = var.deploy_to_vpc ? 1 : 0
  name_prefix = local.name
  vpc_id      = module.vpc[0].vpc_id
  description = "Security allowing certain access for executed lambda"
}
resource "aws_security_group_rule" "ingress_dynamo_db" {
  count = var.deploy_to_vpc ? 1 : 0
  #checkov:skip=CKV_AWS_260:False positive, we restrict by vpc_endpoint_prefix
  #checkov:skip=CKV_AWS_24:False positive, we restrict by vpc_endpoint_prefix
  #checkov:skip=CKV_AWS_25:False positive, we restrict by vpc_endpoint_prefix
  description       = "Allow all TCP traffic from the AWS Vpc Endpoint"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  prefix_list_ids   = [aws_vpc_endpoint.dynamodb[0].prefix_list_id]
  security_group_id = aws_security_group.lambda[0].id
}
resource "aws_security_group_rule" "egress_dynamo_db" {
  count             = var.deploy_to_vpc ? 1 : 0
  description       = "Allow all egress traffic towards vpc endpoint"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  prefix_list_ids   = [aws_vpc_endpoint.dynamodb[0].prefix_list_id]
  security_group_id = aws_security_group.lambda[0].id
}
