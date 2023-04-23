variable "deploy_to_vpc" {
  type        = bool
  description = "If true, will create a VPC and deploy the lambda to it"
  default     = false
}
