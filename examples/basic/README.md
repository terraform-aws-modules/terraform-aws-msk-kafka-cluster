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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.43 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_msk_cluster"></a> [msk\_cluster](#module\_msk\_cluster) | ../.. | n/a |
| <a name="module_msk_cluster_disabled"></a> [msk\_cluster\_disabled](#module\_msk\_cluster\_disabled) | ../.. | n/a |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of the MSK cluster |
| <a name="output_bootstrap_brokers"></a> [bootstrap\_brokers](#output\_bootstrap\_brokers) | Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster |
| <a name="output_bootstrap_brokers_plaintext"></a> [bootstrap\_brokers\_plaintext](#output\_bootstrap\_brokers\_plaintext) | Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster. Contains a value if `encryption_in_transit_client_broker` is set to `PLAINTEXT` or `TLS_PLAINTEXT` |
| <a name="output_bootstrap_brokers_sasl_iam"></a> [bootstrap\_brokers\_sasl\_iam](#output\_bootstrap\_brokers\_sasl\_iam) | One or more DNS names (or IP addresses) and SASL IAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_iam` is set to `true` |
| <a name="output_bootstrap_brokers_sasl_scram"></a> [bootstrap\_brokers\_sasl\_scram](#output\_bootstrap\_brokers\_sasl\_scram) | One or more DNS names (or IP addresses) and SASL SCRAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_scram` is set to `true` |
| <a name="output_bootstrap_brokers_tls"></a> [bootstrap\_brokers\_tls](#output\_bootstrap\_brokers\_tls) | One or more DNS names (or IP addresses) and TLS port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` |
| <a name="output_configuration_arn"></a> [configuration\_arn](#output\_configuration\_arn) | Amazon Resource Name (ARN) of the configuration |
| <a name="output_configuration_latest_revision"></a> [configuration\_latest\_revision](#output\_configuration\_latest\_revision) | Latest revision of the configuration |
| <a name="output_current_version"></a> [current\_version](#output\_current\_version) | Current version of the MSK Cluster used for updates, e.g. `K13V1IB3VIYZZH` |
| <a name="output_scram_secret_association_id"></a> [scram\_secret\_association\_id](#output\_scram\_secret\_association\_id) | Amazon Resource Name (ARN) of the MSK cluster |
| <a name="output_zookeeper_connect_string"></a> [zookeeper\_connect\_string](#output\_zookeeper\_connect\_string) | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster. The returned values are sorted alphbetically |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Apache-2.0 Licensed. See [LICENSE](../../LICENSE).
