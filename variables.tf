variable "create" {
  description = "Determines whether cluster resources will be created"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resources created"
  type        = map(string)
  default     = {}
}

################################################################################
# Cluster
################################################################################

variable "broker_node_az_distribution" {
  description = "The distribution of broker nodes across availability zones ([documentation](https://docs.aws.amazon.com/msk/1.0/apireference/clusters.html#clusters-model-brokerazdistribution)). Currently the only valid value is `DEFAULT`"
  type        = string
  default     = null
}

variable "broker_node_client_subnets" {
  description = "A list of subnets to connect to in client VPC ([documentation](https://docs.aws.amazon.com/msk/1.0/apireference/clusters.html#clusters-prop-brokernodegroupinfo-clientsubnets))"
  type        = list(string)
  default     = []
}

variable "broker_node_connectivity_info" {
  description = "Information about the cluster access configuration"
  type = object({
    vpc_connectivity = optional(object({
      client_authentication = optional(object({
        sasl = optional(object({
          iam   = optional(bool)
          scram = optional(bool)
        }))
        tls = optional(bool)
      }))
    }))
    public_access = optional(object({
      type = optional(string)
    }))
  })
  default = null
}

variable "broker_node_instance_type" {
  description = "Specify the instance type to use for the kafka brokers. e.g. kafka.m5.large. ([Pricing info](https://aws.amazon.com/msk/pricing/))"
  type        = string
  default     = null
}

variable "broker_node_security_groups" {
  description = "A list of the security groups to associate with the elastic network interfaces to control who can communicate with the cluster"
  type        = list(string)
  default     = []
}

variable "broker_node_storage_info" {
  description = "A block that contains information about storage volumes attached to MSK broker nodes"
  type = object({
    ebs_storage_info = optional(object({
      provisioned_throughput = optional(object({
        enabled           = optional(bool)
        volume_throughput = optional(number)
      }))
      volume_size = optional(number, 64)
    }))
  })
  default = null
}

variable "client_authentication" {
  description = "Configuration block for specifying a client authentication"
  type = object({
    sasl = optional(object({
      iam   = optional(bool)
      scram = optional(bool)
    }))
    tls = optional(object({
      certificate_authority_arns = optional(list(string))
    }))
    unauthenticated = optional(bool)
  })
  default = null
}

variable "name" {
  description = "Name of the MSK cluster"
  type        = string
  default     = "msk" # to avoid: Error: cluster_name must be 1 characters or higher
}

variable "encryption_at_rest_kms_key_arn" {
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest"
  type        = string
  default     = null
}

variable "encryption_in_transit_client_broker" {
  description = "Encryption setting for data in transit between clients and brokers. Valid values: `TLS`, `TLS_PLAINTEXT`, and `PLAINTEXT`. Default value is `TLS`"
  type        = string
  default     = null
}

variable "encryption_in_transit_in_cluster" {
  description = "Whether data communication among broker nodes is encrypted. Default value: `true`"
  type        = bool
  default     = null
}

variable "enhanced_monitoring" {
  description = "Specify the desired enhanced MSK CloudWatch monitoring level. See [Monitoring Amazon MSK with Amazon CloudWatch](https://docs.aws.amazon.com/msk/latest/developerguide/monitoring.html)"
  type        = string
  default     = null
}

variable "kafka_version" {
  description = "Specify the desired Kafka software version"
  type        = string
  default     = null
}

variable "cloudwatch_logs_enabled" {
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_class" {
  description = "Specifies the log class of the log group. Possible values are: STANDARD or INFREQUENT_ACCESS."
  type        = string
  default     = null
}


variable "firehose_logs_enabled" {
  description = "Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose"
  type        = bool
  default     = false
}

variable "firehose_delivery_stream" {
  description = "Name of the Kinesis Data Firehose delivery stream to deliver logs to"
  type        = string
  default     = null
}

variable "s3_logs_enabled" {
  description = "Indicates whether you want to enable or disable streaming broker logs to S3"
  type        = bool
  default     = false
}

variable "s3_logs_bucket" {
  description = "Name of the S3 bucket to deliver logs to"
  type        = string
  default     = null
}

variable "s3_logs_prefix" {
  description = "Prefix to append to the folder name"
  type        = string
  default     = null
}

variable "number_of_broker_nodes" {
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets"
  type        = number
  default     = null
}

variable "jmx_exporter_enabled" {
  description = "Indicates whether you want to enable or disable the JMX Exporter"
  type        = bool
  default     = false
}

variable "node_exporter_enabled" {
  description = "Indicates whether you want to enable or disable the Node Exporter"
  type        = bool
  default     = false
}

variable "rebalancing" {
  description = "Configuration block for intelligent rebalancing"
  type = object({
    status = string
  })
  default = null
}

variable "storage_mode" {
  description = "Controls storage mode for supported storage tiers. Valid values are: `LOCAL` or `TIERED`"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = {}
}

################################################################################
# VPC Connection
################################################################################

variable "vpc_connections" {
  description = "Map of VPC Connections to create"
  type = map(object({
    authentication  = string
    client_subnets  = list(string)
    security_groups = list(string)
    vpc_id          = string
    tags            = optional(map(string), {})
  }))
  default  = {}
  nullable = false
}

################################################################################
# Configuration
################################################################################

variable "create_configuration" {
  description = "Determines whether to create a configuration"
  type        = bool
  default     = true
}

variable "configuration_arn" {
  description = "ARN of an externally created configuration to use"
  type        = string
  default     = null
}

variable "configuration_revision" {
  description = "Revision of the externally created configuration to use"
  type        = number
  default     = null
}

variable "configuration_name" {
  description = "Name of the configuration"
  type        = string
  default     = null
}

variable "configuration_description" {
  description = "Description of the configuration"
  type        = string
  default     = null
}

variable "configuration_server_properties" {
  description = "Contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html)"
  type        = map(string)
  default     = {}
}

################################################################################
# Secret(s)
################################################################################

variable "create_scram_secret_association" {
  description = "Determines whether to create SASL/SCRAM secret association"
  type        = bool
  default     = false
}

variable "scram_secret_association_secret_arn_list" {
  description = "List of AWS Secrets Manager secret ARNs to associate with SCRAM"
  type        = list(string)
  default     = []
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
  type = map(object({
    sid           = optional(string)
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    effect        = optional(string)
    resources     = optional(list(string))
    not_resources = optional(list(string))
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    not_principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    conditions = optional(list(object({
      test     = string
      values   = list(string)
      variable = string
    })))
    condition = optional(list(object({
      test     = string
      values   = list(string)
      variable = string
    })))
  }))
  default = null
}

################################################################################
# CloudWatch Log Group
################################################################################

variable "create_cloudwatch_log_group" {
  description = "Determines whether to create a CloudWatch log group"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_name" {
  description = "Name of the Cloudwatch Log Group to deliver logs to"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the log group"
  type        = number
  default     = 0
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

################################################################################
# Storage Autoscaling
################################################################################

variable "enable_storage_autoscaling" {
  description = "Determines whether autoscaling is enabled for storage"
  type        = bool
  default     = true
}

variable "scaling_max_capacity" {
  description = "Max storage capacity for Kafka broker autoscaling"
  type        = number
  default     = 250
}

variable "scaling_role_arn" {
  description = "The ARN of the IAM role that allows Application AutoScaling to modify your scalable target on your behalf. This defaults to an IAM Service-Linked Role"
  type        = string
  default     = null
}

variable "scaling_target_value" {
  description = "The Kafka broker storage utilization at which scaling is initiated"
  type        = number
  default     = 70
}

################################################################################
# Glue Schema Registry & Schema
################################################################################

variable "create_schema_registry" {
  description = "Determines whether to create a Glue schema registry for managing Avro schemas for the cluster"
  type        = bool
  default     = true
}

variable "schema_registries" {
  description = "A map of schema registries to be created"
  type = map(object({
    name        = string
    description = optional(string)
    tags        = optional(map(string), {})
  }))
  default  = {}
  nullable = false
}

variable "schemas" {
  description = "A map schemas to be created within the schema registry"
  type = map(object({
    schema_name          = string
    schema_registry_name = string
    description          = optional(string)
    data_format          = optional(string, "AVRO")
    compatibility        = string
    schema_definition    = string
    tags                 = optional(map(string), {})
  }))
  default  = {}
  nullable = false
}

################################################################################
# Connect Custom Plugin
################################################################################

variable "connect_custom_plugins" {
  description = "Map of custom plugin configuration details (map of maps)"
  type = map(object({
    name           = string
    description    = optional(string)
    content_type   = string
    s3_bucket_arn  = string
    s3_file_key    = string
    object_version = optional(string)
    timeouts = object({
      create = optional(string)
    })
  }))
  default  = {}
  nullable = false
}

variable "connect_custom_plugin_timeouts" {
  description = "Timeout configurations for the connect custom plugins"
  type = object({
    create = optional(string)
  })
  default = null
}

################################################################################
# Connect Worker Configuration
################################################################################

variable "create_connect_worker_configuration" {
  description = "Determines whether to create connect worker configuration"
  type        = bool
  default     = false
}

variable "connect_worker_config_name" {
  description = "The name of the worker configuration"
  type        = string
  default     = null
}

variable "connect_worker_config_description" {
  description = "A summary description of the worker configuration"
  type        = string
  default     = null
}

variable "connect_worker_config_properties_file_content" {
  description = "Contents of connect-distributed.properties file. The value can be either base64 encoded or in raw format"
  type        = string
  default     = null
}
