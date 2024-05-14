################################################################################
# Serverless Cluster
################################################################################

output "serverless_arn" {
  description = "The ARN of the serverless cluster"
  value       = try(aws_msk_serverless_cluster.this[0].arn, null)
}

output "serverless_cluster_uuid" {
  description = "UUID of the serverless cluster, for use in IAM policies"
  value       = try(aws_msk_serverless_cluster.this[0].cluster_uuid, null)
}
