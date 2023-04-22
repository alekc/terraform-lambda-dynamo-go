module "wrap" {
  source = "./modules/wrap"
}
output "api_gw_endpoint" {
  description = "Invocation url for the ApiGW"
  value       = module.wrap.api_gw_endpoint
}
