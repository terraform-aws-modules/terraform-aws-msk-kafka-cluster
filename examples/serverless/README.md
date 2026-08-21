<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.40 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.40 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_msk_serverless_cluster"></a> [msk\_serverless\_cluster](#module\_msk\_serverless\_cluster) | ../../modules/serverless | n/a |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 6.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_serverless_arn"></a> [serverless\_arn](#output\_serverless\_arn) | The ARN of the serverless cluster |
| <a name="output_serverless_cluster_uuid"></a> [serverless\_cluster\_uuid](#output\_serverless\_cluster\_uuid) | UUID of the serverless cluster, for use in IAM policies |
<!-- END_TF_DOCS -->
