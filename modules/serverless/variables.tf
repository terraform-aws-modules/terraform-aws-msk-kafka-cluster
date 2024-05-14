################################################################################
# Serverless Cluster
################################################################################
variable "create" {
  description = "Determines whether cluster resources will be created"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the MSK serverless cluster"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Specifies up to five security groups that control inbound and outbound traffic for the serverless cluster"
  type        = list(string)
  default     = null
}

variable "subnet_ids" {
  description = "A list of subnets in at least two different Availability Zones that host your client applications"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resources created"
  type        = map(string)
  default     = {}
}

################################################################################
# Cluster Policy
################################################################################

variable "create_cluster_policy" {
  description = "Determines whether to create an MSK cluster policy"
  type        = bool
  default     = false
}

variable "cluster_source_policy_documents" {
  description = "Source policy documents for cluster policy"
  type        = list(string)
  default     = null
}

variable "cluster_override_policy_documents" {
  description = "Override policy documents for cluster policy"
  type        = list(string)
  default     = null
}

variable "cluster_policy_statements" {
  description = "Map of policy statements for cluster policy"
  type        = any
  default     = null
}
