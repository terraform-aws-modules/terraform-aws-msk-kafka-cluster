# Cluster
output "arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = element(concat(aws_msk_cluster.this[*].arn, [""]), 0)
}

output "bootstrap_brokers" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster"
  value = element(concat(compact([
    element(concat(aws_msk_cluster.this[*].bootstrap_brokers, [""]), 0),
    element(concat(aws_msk_cluster.this[*].bootstrap_brokers_sasl_iam, [""]), 0),
    element(concat(aws_msk_cluster.this[*].bootstrap_brokers_sasl_scram, [""]), 0),
    element(concat(aws_msk_cluster.this[*].bootstrap_brokers_tls, [""]), 0),
  ]), [""]), 0)
}

output "bootstrap_brokers_plaintext" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster. Contains a value if `encryption_in_transit_client_broker` is set to `PLAINTEXT` or `TLS_PLAINTEXT`"
  value       = element(concat(aws_msk_cluster.this[*].bootstrap_brokers, [""]), 0)
}

output "bootstrap_brokers_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_iam` is set to `true`"
  value       = element(concat(aws_msk_cluster.this[*].bootstrap_brokers_sasl_iam, [""]), 0)
}

output "bootstrap_brokers_sasl_scram" {
  description = "One or more DNS names (or IP addresses) and SASL SCRAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_scram` is set to `true`"
  value       = element(concat(aws_msk_cluster.this[*].bootstrap_brokers_sasl_scram, [""]), 0)
}

output "bootstrap_brokers_tls" {
  description = "One or more DNS names (or IP addresses) and TLS port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS`"
  value       = element(concat(aws_msk_cluster.this[*].bootstrap_brokers_tls, [""]), 0)
}

output "current_version" {
  description = "Current version of the MSK Cluster used for updates, e.g. `K13V1IB3VIYZZH`"
  value       = element(concat(aws_msk_cluster.this[*].current_version, [""]), 0)
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster. The returned values are sorted alphbetically"
  value       = element(concat(aws_msk_cluster.this[*].zookeeper_connect_string, [""]), 0)
}

# Configuration
output "configuration_arn" {
  description = "Amazon Resource Name (ARN) of the configuration"
  value       = element(concat(aws_msk_configuration.this[*].arn, [""]), 0)
}

output "configuration_latest_revision" {
  description = "Latest revision of the configuration"
  value       = element(concat(aws_msk_configuration.this[*].latest_revision, [""]), 0)
}

# SCRAM secret association
output "scram_secret_association_id" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = element(concat(aws_msk_scram_secret_association.this[*].id, [""]), 0)
}

# Schema registry
output "schema_registries" {
  description = "A map of output attributes for the schema registries created"
  value       = aws_glue_registry.this
}

output "schemas" {
  description = "A map of output attributes for the schemas created"
  value       = aws_glue_schema.this
}
