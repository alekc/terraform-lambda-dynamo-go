#module "vpc" {
#  source = "terraform-aws-modules/vpc/aws"
#
#  name = "lambda-poc"
#  cidr = "10.0.0.0/16"
#
#  azs = [
#    "${data.aws_region.current.name}a",
#    "${data.aws_region.current.name}b",
#    "${data.aws_region.current.name}c",
#  ]
#  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#
#}
