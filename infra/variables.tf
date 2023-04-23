variable "deploy_to_vpc" {
  type        = bool
  description = "If true, will create a VPC and deploy the lambda to it"
}
variable "lambda_log_level" {
  type        = string
  description = "Lambda level log. Possible values are debug, info, warning"
  default     = "debug"
}
