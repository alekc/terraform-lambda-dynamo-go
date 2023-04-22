output "api_gw_endpoint" {
  description = "Invocation url for the ApiGW"
  value       = aws_apigatewayv2_stage.main.invoke_url
}
