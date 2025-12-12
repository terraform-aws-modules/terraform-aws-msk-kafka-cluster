################################################################################
# Cluster
################################################################################

resource "aws_msk_cluster" "this" {
  count = var.create ? 1 : 0

  broker_node_group_info {
    az_distribution = var.broker_node_az_distribution
    client_subnets  = var.broker_node_client_subnets

    dynamic "connectivity_info" {
      for_each = var.broker_node_connectivity_info != null ? [var.broker_node_connectivity_info] : []

      content {
        dynamic "public_access" {
          for_each = connectivity_info.value.public_access != null ? [connectivity_info.value.public_access] : []

          content {
            type = public_access.value.type
          }
        }

        dynamic "vpc_connectivity" {
          for_each = connectivity_info.value.vpc_connectivity != null ? [connectivity_info.value.vpc_connectivity] : []

          content {
            dynamic "client_authentication" {
              for_each = vpc_connectivity.value.client_authentication != null ? [vpc_connectivity.value.client_authentication] : []

              content {
                dynamic "sasl" {
                  for_each = client_authentication.value.sasl != null ? [client_authentication.value.sasl] : []

                  content {
                    iam   = sasl.value.iam
                    scram = sasl.value.scram
                  }
                }

                tls = client_authentication.value.tls
              }
            }
          }
        }
      }
    }

    instance_type   = var.broker_node_instance_type
    security_groups = var.broker_node_security_groups

    dynamic "storage_info" {
      for_each = var.broker_node_storage_info != null ? [var.broker_node_storage_info] : []

      content {
        dynamic "ebs_storage_info" {
          for_each = storage_info.value.ebs_storage_info != null ? [storage_info.value.ebs_storage_info] : []

          content {
            dynamic "provisioned_throughput" {
              for_each = ebs_storage_info.value.provisioned_throughput != null ? [ebs_storage_info.value.provisioned_throughput] : []

              content {
                enabled           = provisioned_throughput.value.enabled
                volume_throughput = provisioned_throughput.value.volume_throughput
              }
            }

            volume_size = ebs_storage_info.value.volume_size
          }
        }
      }
    }
  }

  dynamic "client_authentication" {
    for_each = var.client_authentication != null ? [var.client_authentication] : []

    content {
      dynamic "sasl" {
        for_each = client_authentication.value.sasl != null ? [client_authentication.value.sasl] : []

        content {
          iam   = sasl.value.iam
          scram = sasl.value.scram
        }
      }

      dynamic "tls" {
        for_each = client_authentication.value.tls != null ? [client_authentication.value.tls] : []

        content {
          certificate_authority_arns = tls.value.certificate_authority_arns
        }
      }

      unauthenticated = client_authentication.value.unauthenticated
    }
  }

  cluster_name = var.name

  configuration_info {
    arn      = var.create_configuration ? aws_msk_configuration.this[0].arn : var.configuration_arn
    revision = var.create_configuration ? aws_msk_configuration.this[0].latest_revision : var.configuration_revision
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn

    encryption_in_transit {
      client_broker = var.encryption_in_transit_client_broker
      in_cluster    = var.encryption_in_transit_in_cluster
    }
  }

  enhanced_monitoring = var.enhanced_monitoring
  kafka_version       = var.kafka_version

  dynamic "logging_info" {
    for_each = length(regexall("^express", var.broker_node_instance_type)) > 0 ? [] : [true]
    content {
      broker_logs {
        cloudwatch_logs {
          enabled   = var.cloudwatch_logs_enabled
          log_group = var.cloudwatch_logs_enabled ? local.cloudwatch_log_group : null
        }

        firehose {
          enabled         = var.firehose_logs_enabled
          delivery_stream = var.firehose_delivery_stream
        }

        s3 {
          bucket  = var.s3_logs_bucket
          enabled = var.s3_logs_enabled
          prefix  = var.s3_logs_prefix
        }
      }
    }
  }

  number_of_broker_nodes = var.number_of_broker_nodes

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.jmx_exporter_enabled
      }
      node_exporter {
        enabled_in_broker = var.node_exporter_enabled
      }
    }
  }

  dynamic "rebalancing" {
    for_each = var.rebalancing != null ? [var.rebalancing] : []

    content {
      status = rebalancing.value.status
    }
  }

  region       = var.region
  storage_mode = var.storage_mode

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  # required for appautoscaling
  lifecycle {
    ignore_changes = [
      broker_node_group_info[0].storage_info[0].ebs_storage_info[0].volume_size,
    ]
  }

  tags = var.tags
}

################################################################################
# VPC Connection
################################################################################

resource "aws_msk_vpc_connection" "this" {
  for_each = { for k, v in var.vpc_connections : k => v if var.create }

  authentication     = each.value.authentication
  client_subnets     = each.value.client_subnets
  region             = var.region
  security_groups    = each.value.security_groups
  target_cluster_arn = aws_msk_cluster.this[0].arn
  vpc_id             = each.value.vpc_id

  tags = merge(var.tags, each.value.tags)
}

################################################################################
# Cluster Policy
################################################################################

resource "aws_msk_cluster_policy" "this" {
  count = var.create && var.create_cluster_policy ? 1 : 0

  cluster_arn = aws_msk_cluster.this[0].arn
  policy      = data.aws_iam_policy_document.this[0].json
  region      = var.region
}

data "aws_iam_policy_document" "this" {
  count = var.create && var.create_cluster_policy ? 1 : 0

  source_policy_documents   = var.cluster_source_policy_documents
  override_policy_documents = var.cluster_override_policy_documents

  dynamic "statement" {
    for_each = var.cluster_policy_statements != null ? var.cluster_policy_statements : {}

    content {
      sid           = coalesce(statement.value.sid, statement.key)
      actions       = statement.value.actions
      not_actions   = statement.value.not_actions
      effect        = statement.value.effect
      resources     = statement.value.resources != null ? statement.value.resources : [aws_msk_cluster.this[0].arn]
      not_resources = statement.value.not_resources

      dynamic "principals" {
        for_each = statement.value.principals != null ? statement.value.principals : []

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principals != null ? statement.value.not_principals : []

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition != null ? statement.value.condition : []

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

################################################################################
# Configuration
################################################################################

resource "random_id" "this" {
  count = var.create && var.create_configuration ? 1 : 0

  keepers = {
    kafka_version = var.kafka_version
  }

  byte_length = 8
}

resource "aws_msk_configuration" "this" {
  count = var.create && var.create_configuration ? 1 : 0

  name              = format("%s-%s", coalesce(var.configuration_name, var.name), random_id.this[0].dec)
  description       = var.configuration_description
  kafka_versions    = [random_id.this[0].keepers.kafka_version]
  region            = var.region
  server_properties = join("\n", [for k, v in var.configuration_server_properties : format("%s = %s", k, v)])

  lifecycle {
    create_before_destroy = true
  }
}

################################################################################
# Secret(s)
################################################################################

resource "aws_msk_scram_secret_association" "this" {
  count = var.create && var.create_scram_secret_association && try(var.client_authentication.sasl.scram, false) ? 1 : 0

  cluster_arn     = aws_msk_cluster.this[0].arn
  region          = var.region
  secret_arn_list = var.scram_secret_association_secret_arn_list
}

################################################################################
# CloudWatch Log Group
################################################################################

locals {
  cloudwatch_log_group = var.create && var.create_cloudwatch_log_group ? aws_cloudwatch_log_group.this[0].name : var.cloudwatch_log_group_name
}

resource "aws_cloudwatch_log_group" "this" {
  count = var.create && var.create_cloudwatch_log_group ? 1 : 0

  name              = coalesce(var.cloudwatch_log_group_name, "/aws/msk/${var.name}")
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id
  log_group_class   = var.cloudwatch_log_group_class
  region            = var.region

  tags = var.tags
}

################################################################################
# Storage Autoscaling
################################################################################

resource "aws_appautoscaling_target" "this" {
  count = var.create && var.enable_storage_autoscaling ? 1 : 0

  max_capacity       = var.scaling_max_capacity
  min_capacity       = 1
  region             = var.region
  role_arn           = var.scaling_role_arn
  resource_id        = aws_msk_cluster.this[0].arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"

  tags = var.tags
}

resource "aws_appautoscaling_policy" "this" {
  count = var.create && var.enable_storage_autoscaling ? 1 : 0

  name               = "${var.name}-broker-storage-scaling"
  policy_type        = "TargetTrackingScaling"
  region             = var.region
  resource_id        = aws_msk_cluster.this[0].arn
  scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = var.scaling_target_value
  }
}

################################################################################
# Glue Schema Registry & Schema
################################################################################

resource "aws_glue_registry" "this" {
  for_each = { for k, v in var.schema_registries : k => v if var.create && var.create_schema_registry }

  registry_name = each.value.name
  description   = each.value.description
  region        = var.region

  tags = merge(var.tags, each.value.tags)
}

resource "aws_glue_schema" "this" {
  for_each = { for k, v in var.schemas : k => v if var.create && var.create_schema_registry }

  schema_name       = each.value.schema_name
  description       = each.value.description
  registry_arn      = aws_glue_registry.this[each.value.schema_registry_name].arn
  data_format       = each.value.data_format
  compatibility     = each.value.compatibility
  schema_definition = each.value.schema_definition
  region            = var.region

  tags = merge(var.tags, each.value.tags)
}
