## Usage

See [`examples`](https://github.com/clowdhaus/terraform-aws-msk-kafka-cluster/tree/main/examples) directory for working examples to reference:

```hcl
module "msk_kafka_cluster" {
  source = "clowdhaus/msk-kafka-cluster/aws"

  name                   = local.name
  kafka_version          = "2.8.0"
  number_of_broker_nodes = 3
  enhanced_monitoring    = "PER_TOPIC_PER_PARTITION"

  broker_node_client_subnets  = ["subnet-12345678", "subnet-024681012", "subnet-87654321"]
  broker_node_ebs_volume_size = 20
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

  client_authentication_sasl_scram         = true
  create_scram_secret_association          = true
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
        fields = [{
          name = "f1"
          type = "int"
          }, {
          name = "f2"
          type = "string"
          }, {
          name = "f3"
          type = "boolean"
        }]
      })
      tags = { Team = "Team B" }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Examples

Examples codified under the [`examples`](https://github.com/clowdhaus/terraform-aws-msk-kafka-cluster/tree/main/examples) are intended to give users references for how to use the module(s) as well as testing/validating changes to the source code of the module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow maintainers to test your changes and to keep the examples up to date for users. Thank you!

- [Basic](https://github.com/clowdhaus/terraform-aws-msk-kafka-cluster/tree/main/examples/basic)
- [Complete](https://github.com/clowdhaus/terraform-aws-msk-kafka-cluster/tree/main/examples/complete)