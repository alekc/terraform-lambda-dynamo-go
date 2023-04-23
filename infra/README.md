# infra

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.64 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_wrap"></a> [wrap](#module\_wrap) | ./modules/wrap | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deploy_to_vpc"></a> [deploy\_to\_vpc](#input\_deploy\_to\_vpc) | If true, will create a VPC and deploy the lambda to it | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gw_endpoint"></a> [api\_gw\_endpoint](#output\_api\_gw\_endpoint) | Invocation url for the ApiGW |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
