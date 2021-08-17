################################################################################
# MSK Cluster
################################################################################

# Cluster
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

# Configuration
output "configuration_arn" {
  description = "Amazon Resource Name (ARN) of the configuration"
  value       = module.msk_cluster.configuration_arn
}

output "configuration_latest_revision" {
  description = "Latest revision of the configuration"
  value       = module.msk_cluster.configuration_latest_revision
}

# SCRAM secret association
output "scram_secret_association_id" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = module.msk_cluster.scram_secret_association_id
}
