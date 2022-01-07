################################################################################
# Cluster
################################################################################

output "arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = module.msk_cluster.arn
}

output "bootstrap_brokers" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster"
  value       = module.msk_cluster.bootstrap_brokers
}

output "bootstrap_brokers_plaintext" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster. Contains a value if `encryption_in_transit_client_broker` is set to `PLAINTEXT` or `TLS_PLAINTEXT`"
  value       = module.msk_cluster.bootstrap_brokers_plaintext
}

output "bootstrap_brokers_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_iam` is set to `true`"
  value       = module.msk_cluster.bootstrap_brokers_sasl_iam
}

output "bootstrap_brokers_sasl_scram" {
  description = "One or more DNS names (or IP addresses) and SASL SCRAM port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS` and `client_authentication_sasl_scram` is set to `true`"
  value       = module.msk_cluster.bootstrap_brokers_sasl_scram
}

output "bootstrap_brokers_tls" {
  description = "One or more DNS names (or IP addresses) and TLS port pairs. This attribute will have a value if `encryption_in_transit_client_broker` is set to `TLS_PLAINTEXT` or `TLS`"
  value       = module.msk_cluster.bootstrap_brokers_tls
}

output "current_version" {
  description = "Current version of the MSK Cluster used for updates, e.g. `K13V1IB3VIYZZH`"
  value       = module.msk_cluster.current_version
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster. The returned values are sorted alphbetically"
  value       = module.msk_cluster.zookeeper_connect_string
}

output "zookeeper_connect_string_tls" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS. The returned values are sorted alphbetically"
  value       = module.msk_cluster.zookeeper_connect_string_tls
}

################################################################################
# Configuration
################################################################################

output "configuration_arn" {
  description = "Amazon Resource Name (ARN) of the configuration"
  value       = module.msk_cluster.configuration_arn
}

output "configuration_latest_revision" {
  description = "Latest revision of the configuration"
  value       = module.msk_cluster.configuration_latest_revision
}

################################################################################
# Secret(s)
################################################################################

output "scram_secret_association_id" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = module.msk_cluster.scram_secret_association_id
}

################################################################################
# CloudWatch Log Group
################################################################################

output "log_group_arn" {
  description = "The Amazon Resource Name (ARN) specifying the log group"
  value       = module.msk_cluster.log_group_arn
}

################################################################################
# Storage Autoscaling
################################################################################

output "appautoscaling_policy_arn" {
  description = "The ARN assigned by AWS to the scaling policy"
  value       = module.msk_cluster.appautoscaling_policy_arn
}

output "appautoscaling_policy_name" {
  description = "The scaling policy's name"
  value       = module.msk_cluster.appautoscaling_policy_name
}

output "appautoscaling_policy_policy_type" {
  description = "The scaling policy's type"
  value       = module.msk_cluster.appautoscaling_policy_policy_type
}

################################################################################
# Glue Schema Registry & Schema
################################################################################

output "schema_registries" {
  description = "A map of output attributes for the schema registries created"
  value       = module.msk_cluster.schema_registries
}

output "schemas" {
  description = "A map of output attributes for the schemas created"
  value       = module.msk_cluster.schemas
}

################################################################################
# Connect Custom Plugin
################################################################################

output "connect_custom_plugins" {
  description = "A map of output attributes for the connect custom plugins created"
  value       = module.msk_cluster.connect_custom_plugins
}

################################################################################
# Connect Worker Configuration
################################################################################

output "connect_worker_configuration_arn" {
  description = "The Amazon Resource Name (ARN) of the worker configuration"
  value       = module.msk_cluster.connect_worker_configuration_arn
}

output "connect_worker_configuration_latest_revision" {
  description = "An ID of the latest successfully created revision of the worker configuration"
  value       = module.msk_cluster.connect_worker_configuration_latest_revision
}
