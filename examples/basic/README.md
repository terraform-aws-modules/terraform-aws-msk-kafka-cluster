# Basic MSK Kafka Cluster Example

Configuration in this directory creates:

- A disabled AWS MSK Kafka cluster (does not create any resources, demonstrates how to disable cluster and resource creation)
- AWS MSK Kafka cluster with default module settings

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.30 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_msk_cluster"></a> [msk\_cluster](#module\_msk\_cluster) | ../.. | n/a |
| <a name="module_msk_cluster_disabled"></a> [msk\_cluster\_disabled](#module\_msk\_cluster\_disabled) | ../.. | n/a |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_appautoscaling_policy_arn"></a> [appautoscaling\_policy\_arn](#output\_appautoscaling\_policy\_arn) | The ARN assigned by AWS to the scaling policy |
| <a name="output_appautoscaling_policy_name"></a> [appautoscaling\_policy\_name](#output\_appautoscaling\_policy\_name) | The scaling policy's name |
| <a name="output_appautoscaling_policy_policy_type"></a> [appautoscaling\_policy\_policy\_type](#output\_appautoscaling\_policy\_policy\_type) | The scaling policy's type |
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of the MSK cluster |
| <a name="output_bootstrap_brokers"></a> [bootstrap\_brokers](#output\_bootstrap\_brokers) | Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster |
| <a name="output_bootstrap_brokers_plaintext"></a> [bootstrap\_brokers\_plaintext](#output\_bootstrap\_brokers\_plaintext) | Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster. Contains a value if `encryption_in_transit_client_broker` is set to `PLAINTEXT` or `TLS_PLAINTEXT` |
| <a name="output_bootstrap_brokers_public"></a> [bootstrap\_brokers\_public](#output\_bootstrap\_brokers\_public) | Comma separated list of one or more hostname:port pairs of Kafka brokers suitable to bootstrap connectivity to the Kafka cluster |
| <a name="output_bootstrap_brokers_public_sasl_iam"></a> [bootstrap\_brokers\_public\_sasl\_iam](#output\_bootstrap\_brokers\_public\_sasl\_iam) | One or more DNS names (or IP addresses) and SASL IAM port pairs |
| <a name="output_bootstrap_brokers_public_sasl_scram"></a> [bootstrap\_brokers\_public\_sasl\_scram](#output\_bootstrap\_brokers\_public\_sasl\_scram) | One or more DNS names (or IP addresses) and SASL SCRAM port pairs |
| <a name="output_bootstrap_brokers_public_tls"></a> [bootstrap\_brokers\_public\_tls](#output\_bootstrap\_brokers\_public\_tls) | One or more DNS names (or IP addresses) and TLS port pairs |
| <a name="output_bootstrap_brokers_sasl_iam"></a> [bootstrap\_brokers\_sasl\_iam](#output\_bootstrap\_brokers\_sasl\_iam) | One or more DNS names (or IP addresses) and SASL IAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_iam` is set to `true` |
| <a name="output_bootstrap_brokers_sasl_scram"></a> [bootstrap\_brokers\_sasl\_scram](#output\_bootstrap\_brokers\_sasl\_scram) | One or more DNS names (or IP addresses) and SASL SCRAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_scram` is set to `true` |
| <a name="output_bootstrap_brokers_tls"></a> [bootstrap\_brokers\_tls](#output\_bootstrap\_brokers\_tls) | One or more DNS names (or IP addresses) and TLS port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the MSK cluster |
| <a name="output_cluster_uuid"></a> [cluster\_uuid](#output\_cluster\_uuid) | UUID of the MSK cluster, for use in IAM policies |
| <a name="output_configuration_arn"></a> [configuration\_arn](#output\_configuration\_arn) | Amazon Resource Name (ARN) of the configuration |
| <a name="output_configuration_latest_revision"></a> [configuration\_latest\_revision](#output\_configuration\_latest\_revision) | Latest revision of the configuration |
| <a name="output_connect_custom_plugins"></a> [connect\_custom\_plugins](#output\_connect\_custom\_plugins) | A map of output attributes for the connect custom plugins created |
| <a name="output_connect_worker_configuration_arn"></a> [connect\_worker\_configuration\_arn](#output\_connect\_worker\_configuration\_arn) | The Amazon Resource Name (ARN) of the worker configuration |
| <a name="output_connect_worker_configuration_latest_revision"></a> [connect\_worker\_configuration\_latest\_revision](#output\_connect\_worker\_configuration\_latest\_revision) | An ID of the latest successfully created revision of the worker configuration |
| <a name="output_current_version"></a> [current\_version](#output\_current\_version) | Current version of the MSK Cluster used for updates, e.g. `K13V1IB3VIYZZH` |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | The Amazon Resource Name (ARN) specifying the log group |
| <a name="output_schema_registries"></a> [schema\_registries](#output\_schema\_registries) | A map of output attributes for the schema registries created |
| <a name="output_schemas"></a> [schemas](#output\_schemas) | A map of output attributes for the schemas created |
| <a name="output_scram_secret_association_id"></a> [scram\_secret\_association\_id](#output\_scram\_secret\_association\_id) | Amazon Resource Name (ARN) of the MSK cluster |
| <a name="output_zookeeper_connect_string"></a> [zookeeper\_connect\_string](#output\_zookeeper\_connect\_string) | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster. The returned values are sorted alphbetically |
| <a name="output_zookeeper_connect_string_tls"></a> [zookeeper\_connect\_string\_tls](#output\_zookeeper\_connect\_string\_tls) | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS. The returned values are sorted alphbetically |
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/blob/master/LICENSE).
