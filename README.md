# AWS MSK Kafka Cluster Terraform module

Terraform module which creates AWS MSK (Managed Streaming for Kafka) resources.

[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

## Usage

See [`examples`](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/tree/master/examples) directory for working examples to reference:

```hcl
module "msk_kafka_cluster" {
  source = "terraform-aws-modules/msk-kafka-cluster/aws"

  name                   = local.name
  kafka_version          = "3.5.1"
  number_of_broker_nodes = 3
  enhanced_monitoring    = "PER_TOPIC_PER_PARTITION"

  broker_node_client_subnets = ["subnet-12345678", "subnet-024681012", "subnet-87654321"]
  broker_node_storage_info = {
    ebs_storage_info = { volume_size = 100 }
  }
  broker_node_instance_type   = "kafka.t3.small"
  broker_node_security_groups = ["sg-12345678"]

  encryption_in_transit_client_broker = "TLS"
  encryption_in_transit_in_cluster    = true

  configuration_name        = "example-configuration"
  configuration_description = "Example configuration"
  configuration_server_properties = {
    "auto.create.topics.enable" = true
    "delete.topic.enable"       = true
  }

  jmx_exporter_enabled    = true
  node_exporter_enabled   = true
  cloudwatch_logs_enabled = true
  s3_logs_enabled         = true
  s3_logs_bucket          = "aws-msk-kafka-cluster-logs"
  s3_logs_prefix          = local.name

  scaling_max_capacity = 512
  scaling_target_value = 80

  client_authentication = {
    sasl = { scram = true }
  }
  create_scram_secret_association = true
  scram_secret_association_secret_arn_list = [
    aws_secretsmanager_secret.one.arn,
    aws_secretsmanager_secret.two.arn,
  ]

  # AWS Glue Registry
  schema_registries = {
    team_a = {
      name        = "team_a"
      description = "Schema registry for Team A"
    }
    team_b = {
      name        = "team_b"
      description = "Schema registry for Team B"
    }
  }

  # AWS Glue Schemas
  schemas = {
    team_a_tweets = {
      schema_registry_name = "team_a"
      schema_name          = "tweets"
      description          = "Schema that contains all the tweets"
      compatibility        = "FORWARD"
      schema_definition    = "{\"type\": \"record\", \"name\": \"r1\", \"fields\": [ {\"name\": \"f1\", \"type\": \"int\"}, {\"name\": \"f2\", \"type\": \"string\"} ]}"
      tags                 = { Team = "Team A" }
    }
    team_b_records = {
      schema_registry_name = "team_b"
      schema_name          = "records"
      description          = "Schema that contains all the records"
      compatibility        = "FORWARD"
      team_b_records = {
        schema_registry_name = "team_b"
        schema_name          = "records"
        description          = "Schema that contains all the records"
        compatibility        = "FORWARD"
        schema_definition = jsonencode({
          type = "record"
          name = "r1"
          fields = [
            {
              name = "f1"
              type = "int"
            },
            {
              name = "f2"
              type = "string"
            },
            {
              name = "f3"
              type = "boolean"
            }
          ]
        })
        tags = { Team = "Team B" }
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Examples

Examples codified under the [`examples`](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/tree/master/examples) are intended to give users references for how to use the module(s) as well as testing/validating changes to the source code of the module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow maintainers to test your changes and to keep the examples up to date for users. Thank you!

- [Basic](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/tree/master/examples/basic)
- [Complete](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/tree/master/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.30 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.30 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_glue_registry.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_registry) | resource |
| [aws_glue_schema.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_schema) | resource |
| [aws_msk_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster) | resource |
| [aws_msk_cluster_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster_policy) | resource |
| [aws_msk_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_configuration) | resource |
| [aws_msk_scram_secret_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_scram_secret_association) | resource |
| [aws_msk_vpc_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_vpc_connection) | resource |
| [aws_mskconnect_custom_plugin.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_custom_plugin) | resource |
| [aws_mskconnect_worker_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mskconnect_worker_configuration) | resource |
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_broker_node_az_distribution"></a> [broker\_node\_az\_distribution](#input\_broker\_node\_az\_distribution) | The distribution of broker nodes across availability zones ([documentation](https://docs.aws.amazon.com/msk/1.0/apireference/clusters.html#clusters-model-brokerazdistribution)). Currently the only valid value is `DEFAULT` | `string` | `null` | no |
| <a name="input_broker_node_client_subnets"></a> [broker\_node\_client\_subnets](#input\_broker\_node\_client\_subnets) | A list of subnets to connect to in client VPC ([documentation](https://docs.aws.amazon.com/msk/1.0/apireference/clusters.html#clusters-prop-brokernodegroupinfo-clientsubnets)) | `list(string)` | `[]` | no |
| <a name="input_broker_node_connectivity_info"></a> [broker\_node\_connectivity\_info](#input\_broker\_node\_connectivity\_info) | Information about the cluster access configuration | `any` | `{}` | no |
| <a name="input_broker_node_instance_type"></a> [broker\_node\_instance\_type](#input\_broker\_node\_instance\_type) | Specify the instance type to use for the kafka brokers. e.g. kafka.m5.large. ([Pricing info](https://aws.amazon.com/msk/pricing/)) | `string` | `null` | no |
| <a name="input_broker_node_security_groups"></a> [broker\_node\_security\_groups](#input\_broker\_node\_security\_groups) | A list of the security groups to associate with the elastic network interfaces to control who can communicate with the cluster | `list(string)` | `[]` | no |
| <a name="input_broker_node_storage_info"></a> [broker\_node\_storage\_info](#input\_broker\_node\_storage\_info) | A block that contains information about storage volumes attached to MSK broker nodes | `any` | `{}` | no |
| <a name="input_client_authentication"></a> [client\_authentication](#input\_client\_authentication) | Configuration block for specifying a client authentication | `any` | `{}` | no |
| <a name="input_cloudwatch_log_group_class"></a> [cloudwatch\_log\_group\_class](#input\_cloudwatch\_log\_group\_class) | Specifies the log class of the log group. Possible values are: STANDARD or INFREQUENT\_ACCESS. | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_kms_key_id"></a> [cloudwatch\_log\_group\_kms\_key\_id](#input\_cloudwatch\_log\_group\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | Name of the Cloudwatch Log Group to deliver logs to | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the log group | `number` | `0` | no |
| <a name="input_cloudwatch_logs_enabled"></a> [cloudwatch\_logs\_enabled](#input\_cloudwatch\_logs\_enabled) | Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs | `bool` | `false` | no |
| <a name="input_cluster_override_policy_documents"></a> [cluster\_override\_policy\_documents](#input\_cluster\_override\_policy\_documents) | Override policy documents for cluster policy | `list(string)` | `null` | no |
| <a name="input_cluster_policy_statements"></a> [cluster\_policy\_statements](#input\_cluster\_policy\_statements) | Map of policy statements for cluster policy | `any` | `null` | no |
| <a name="input_cluster_source_policy_documents"></a> [cluster\_source\_policy\_documents](#input\_cluster\_source\_policy\_documents) | Source policy documents for cluster policy | `list(string)` | `null` | no |
| <a name="input_configuration_arn"></a> [configuration\_arn](#input\_configuration\_arn) | ARN of an externally created configuration to use | `string` | `null` | no |
| <a name="input_configuration_description"></a> [configuration\_description](#input\_configuration\_description) | Description of the configuration | `string` | `null` | no |
| <a name="input_configuration_name"></a> [configuration\_name](#input\_configuration\_name) | Name of the configuration | `string` | `null` | no |
| <a name="input_configuration_revision"></a> [configuration\_revision](#input\_configuration\_revision) | Revision of the externally created configuration to use | `number` | `null` | no |
| <a name="input_configuration_server_properties"></a> [configuration\_server\_properties](#input\_configuration\_server\_properties) | Contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html) | `map(string)` | `{}` | no |
| <a name="input_connect_custom_plugin_timeouts"></a> [connect\_custom\_plugin\_timeouts](#input\_connect\_custom\_plugin\_timeouts) | Timeout configurations for the connect custom plugins | `map(string)` | <pre>{<br/>  "create": null<br/>}</pre> | no |
| <a name="input_connect_custom_plugins"></a> [connect\_custom\_plugins](#input\_connect\_custom\_plugins) | Map of custom plugin configuration details (map of maps) | `any` | `{}` | no |
| <a name="input_connect_worker_config_description"></a> [connect\_worker\_config\_description](#input\_connect\_worker\_config\_description) | A summary description of the worker configuration | `string` | `null` | no |
| <a name="input_connect_worker_config_name"></a> [connect\_worker\_config\_name](#input\_connect\_worker\_config\_name) | The name of the worker configuration | `string` | `null` | no |
| <a name="input_connect_worker_config_properties_file_content"></a> [connect\_worker\_config\_properties\_file\_content](#input\_connect\_worker\_config\_properties\_file\_content) | Contents of connect-distributed.properties file. The value can be either base64 encoded or in raw format | `string` | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Determines whether cluster resources will be created | `bool` | `true` | no |
| <a name="input_create_cloudwatch_log_group"></a> [create\_cloudwatch\_log\_group](#input\_create\_cloudwatch\_log\_group) | Determines whether to create a CloudWatch log group | `bool` | `true` | no |
| <a name="input_create_cluster_policy"></a> [create\_cluster\_policy](#input\_create\_cluster\_policy) | Determines whether to create an MSK cluster policy | `bool` | `false` | no |
| <a name="input_create_configuration"></a> [create\_configuration](#input\_create\_configuration) | Determines whether to create a configuration | `bool` | `true` | no |
| <a name="input_create_connect_worker_configuration"></a> [create\_connect\_worker\_configuration](#input\_create\_connect\_worker\_configuration) | Determines whether to create connect worker configuration | `bool` | `false` | no |
| <a name="input_create_schema_registry"></a> [create\_schema\_registry](#input\_create\_schema\_registry) | Determines whether to create a Glue schema registry for managing Avro schemas for the cluster | `bool` | `true` | no |
| <a name="input_create_scram_secret_association"></a> [create\_scram\_secret\_association](#input\_create\_scram\_secret\_association) | Determines whether to create SASL/SCRAM secret association | `bool` | `false` | no |
| <a name="input_enable_storage_autoscaling"></a> [enable\_storage\_autoscaling](#input\_enable\_storage\_autoscaling) | Determines whether autoscaling is enabled for storage | `bool` | `true` | no |
| <a name="input_encryption_at_rest_kms_key_arn"></a> [encryption\_at\_rest\_kms\_key\_arn](#input\_encryption\_at\_rest\_kms\_key\_arn) | You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest | `string` | `null` | no |
| <a name="input_encryption_in_transit_client_broker"></a> [encryption\_in\_transit\_client\_broker](#input\_encryption\_in\_transit\_client\_broker) | Encryption setting for data in transit between clients and brokers. Valid values: `TLS`, `TLS_PLAINTEXT`, and `PLAINTEXT`. Default value is `TLS` | `string` | `null` | no |
| <a name="input_encryption_in_transit_in_cluster"></a> [encryption\_in\_transit\_in\_cluster](#input\_encryption\_in\_transit\_in\_cluster) | Whether data communication among broker nodes is encrypted. Default value: `true` | `bool` | `null` | no |
| <a name="input_enhanced_monitoring"></a> [enhanced\_monitoring](#input\_enhanced\_monitoring) | Specify the desired enhanced MSK CloudWatch monitoring level. See [Monitoring Amazon MSK with Amazon CloudWatch](https://docs.aws.amazon.com/msk/latest/developerguide/monitoring.html) | `string` | `null` | no |
| <a name="input_firehose_delivery_stream"></a> [firehose\_delivery\_stream](#input\_firehose\_delivery\_stream) | Name of the Kinesis Data Firehose delivery stream to deliver logs to | `string` | `null` | no |
| <a name="input_firehose_logs_enabled"></a> [firehose\_logs\_enabled](#input\_firehose\_logs\_enabled) | Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose | `bool` | `false` | no |
| <a name="input_jmx_exporter_enabled"></a> [jmx\_exporter\_enabled](#input\_jmx\_exporter\_enabled) | Indicates whether you want to enable or disable the JMX Exporter | `bool` | `false` | no |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | Specify the desired Kafka software version | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the MSK cluster | `string` | `"msk"` | no |
| <a name="input_node_exporter_enabled"></a> [node\_exporter\_enabled](#input\_node\_exporter\_enabled) | Indicates whether you want to enable or disable the Node Exporter | `bool` | `false` | no |
| <a name="input_number_of_broker_nodes"></a> [number\_of\_broker\_nodes](#input\_number\_of\_broker\_nodes) | The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets | `number` | `null` | no |
| <a name="input_s3_logs_bucket"></a> [s3\_logs\_bucket](#input\_s3\_logs\_bucket) | Name of the S3 bucket to deliver logs to | `string` | `null` | no |
| <a name="input_s3_logs_enabled"></a> [s3\_logs\_enabled](#input\_s3\_logs\_enabled) | Indicates whether you want to enable or disable streaming broker logs to S3 | `bool` | `false` | no |
| <a name="input_s3_logs_prefix"></a> [s3\_logs\_prefix](#input\_s3\_logs\_prefix) | Prefix to append to the folder name | `string` | `null` | no |
| <a name="input_scaling_max_capacity"></a> [scaling\_max\_capacity](#input\_scaling\_max\_capacity) | Max storage capacity for Kafka broker autoscaling | `number` | `250` | no |
| <a name="input_scaling_role_arn"></a> [scaling\_role\_arn](#input\_scaling\_role\_arn) | The ARN of the IAM role that allows Application AutoScaling to modify your scalable target on your behalf. This defaults to an IAM Service-Linked Role | `string` | `null` | no |
| <a name="input_scaling_target_value"></a> [scaling\_target\_value](#input\_scaling\_target\_value) | The Kafka broker storage utilization at which scaling is initiated | `number` | `70` | no |
| <a name="input_schema_registries"></a> [schema\_registries](#input\_schema\_registries) | A map of schema registries to be created | `map(any)` | `{}` | no |
| <a name="input_schemas"></a> [schemas](#input\_schemas) | A map schemas to be created within the schema registry | `map(any)` | `{}` | no |
| <a name="input_scram_secret_association_secret_arn_list"></a> [scram\_secret\_association\_secret\_arn\_list](#input\_scram\_secret\_association\_secret\_arn\_list) | List of AWS Secrets Manager secret ARNs to associate with SCRAM | `list(string)` | `[]` | no |
| <a name="input_storage_mode"></a> [storage\_mode](#input\_storage\_mode) | Controls storage mode for supported storage tiers. Valid values are: `LOCAL` or `TIERED` | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources created | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Create, update, and delete timeout configurations for the cluster | `map(string)` | `{}` | no |
| <a name="input_vpc_connections"></a> [vpc\_connections](#input\_vpc\_connections) | Map of VPC Connections to create | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_appautoscaling_policy_arn"></a> [appautoscaling\_policy\_arn](#output\_appautoscaling\_policy\_arn) | The ARN assigned by AWS to the scaling policy |
| <a name="output_appautoscaling_policy_name"></a> [appautoscaling\_policy\_name](#output\_appautoscaling\_policy\_name) | The scaling policy's name |
| <a name="output_appautoscaling_policy_policy_type"></a> [appautoscaling\_policy\_policy\_type](#output\_appautoscaling\_policy\_policy\_type) | The scaling policy's type |
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of the MSK cluster |
| <a name="output_bootstrap_brokers"></a> [bootstrap\_brokers](#output\_bootstrap\_brokers) | Comma separated list of one or more hostname:port pairs of Kafka brokers suitable to bootstrap connectivity to the Kafka cluster |
| <a name="output_bootstrap_brokers_plaintext"></a> [bootstrap\_brokers\_plaintext](#output\_bootstrap\_brokers\_plaintext) | Comma separated list of one or more hostname:port pairs of Kafka brokers suitable to bootstrap connectivity to the Kafka cluster. Contains a value if `encryption_in_transit_client_broker` is set to `PLAINTEXT` or `TLS_PLAINTEXT` |
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
| <a name="output_vpc_connections"></a> [vpc\_connections](#output\_vpc\_connections) | A map of output attributes for the VPC connections created |
| <a name="output_zookeeper_connect_string"></a> [zookeeper\_connect\_string](#output\_zookeeper\_connect\_string) | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster. The returned values are sorted alphabetically |
| <a name="output_zookeeper_connect_string_tls"></a> [zookeeper\_connect\_string\_tls](#output\_zookeeper\_connect\_string\_tls) | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS. The returned values are sorted alphabetically |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/blob/master/LICENSE).
