# Cluster
output "arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = try(aws_msk_cluster.this[0].arn, "")
}

output "bootstrap_brokers" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster"
  value = compact([
    try(aws_msk_cluster.this[0].bootstrap_brokers, ""),
    try(aws_msk_cluster.this[0].bootstrap_brokers_sasl_iam, ""),
    try(aws_msk_cluster.this[0].bootstrap_brokers_sasl_scram, ""),
    try(aws_msk_cluster.this[0].bootstrap_brokers_tls, ""),
  ])
}

output "bootstrap_brokers_plaintext" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster. Contains a value if `encryption_in_transit_client_broker` is set to `PLAINTEXT` or `TLS_PLAINTEXT`"
  value       = try(aws_msk_cluster.this[0].bootstrap_brokers, "")
}

output "bootstrap_brokers_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_iam` is set to `true`"
  value       = try(aws_msk_cluster.this[0].bootstrap_brokers_sasl_iam, "")
}

output "bootstrap_brokers_sasl_scram" {
  description = "One or more DNS names (or IP addresses) and SASL SCRAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_scram` is set to `true`"
  value       = try(aws_msk_cluster.this[0].bootstrap_brokers_sasl_scram, "")
}

output "bootstrap_brokers_tls" {
  description = "One or more DNS names (or IP addresses) and TLS port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS`"
  value       = try(aws_msk_cluster.this[0].bootstrap_brokers_tls, "")
}

output "current_version" {
  description = "Current version of the MSK Cluster used for updates, e.g. `K13V1IB3VIYZZH`"
  value       = try(aws_msk_cluster.this[0].current_version, "")
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster. The returned values are sorted alphbetically"
  value       = try(aws_msk_cluster.this[0].zookeeper_connect_string, "")
}

output "zookeeper_connect_string_tls" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS. The returned values are sorted alphbetically"
  value       = try(aws_msk_cluster.this[0].zookeeper_connect_string_tls, "")
}

# Configuration
output "configuration_arn" {
  description = "Amazon Resource Name (ARN) of the configuration"
  value       = try(aws_msk_configuration.this[0].arn, "")
}

output "configuration_latest_revision" {
  description = "Latest revision of the configuration"
  value       = try(aws_msk_configuration.this[0].latest_revision, "")
}

# SCRAM secret association
output "scram_secret_association_id" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = try(aws_msk_scram_secret_association.this[0].id, "")
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
