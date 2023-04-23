module "wrap" {
  source           = "./modules/wrap"
  deploy_to_vpc    = var.deploy_to_vpc
  lambda_log_level = var.lambda_log_level
}
output "api_gw_endpoint" {
  description = "Invocation url for the ApiGW"
  value       = module.wrap.api_gw_endpoint
}
