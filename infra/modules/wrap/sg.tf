resource "aws_security_group" "lambda" {
  name_prefix = local.name
  vpc_id      = module.vpc.vpc_id
  description = "Security allowing certain access for executed lambda"
}
resource "aws_security_group_rule" "ingress_dynamo_db" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  prefix_list_ids   = [aws_vpc_endpoint.dynamodb.prefix_list_id]
  security_group_id = aws_security_group.lambda.id
}
resource "aws_security_group_rule" "egress_dynamo_db" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  prefix_list_ids   = [aws_vpc_endpoint.dynamodb.prefix_list_id]
  security_group_id = aws_security_group.lambda.id
}
