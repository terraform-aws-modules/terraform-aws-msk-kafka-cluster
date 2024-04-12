output "serverless_arn" {
  description = "The ARN of the serverless cluster"
  value       = module.msk_serverless_cluster.serverless_arn
}

output "serverless_cluster_uuid" {
  description = "UUID of the serverless cluster, for use in IAM policies"
  value       = module.msk_serverless_cluster.serverless_cluster_uuid
}
