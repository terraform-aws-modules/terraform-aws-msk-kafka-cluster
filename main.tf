################################################################################
# Cluster
################################################################################

resource "aws_msk_cluster" "this" {
  count = var.create ? 1 : 0

  broker_node_group_info {
    az_distribution = var.broker_node_az_distribution
    client_subnets  = var.broker_node_client_subnets

    dynamic "connectivity_info" {
      for_each = length(var.broker_node_connectivity_info) > 0 ? [var.broker_node_connectivity_info] : []

      content {
        dynamic "public_access" {
          for_each = try([connectivity_info.value.public_access], [])

          content {
            type = try(public_access.value.type, null)
          }
        }

        dynamic "vpc_connectivity" {
          for_each = try([connectivity_info.value.vpc_connectivity], [])

          content {
            dynamic "client_authentication" {
              for_each = try([vpc_connectivity.value.client_authentication], [])

              content {
                dynamic "sasl" {
                  for_each = try([client_authentication.value.sasl], [])

                  content {
                    iam   = try(sasl.value.iam, null)
                    scram = try(sasl.value.scram, null)
                  }
                }

                tls = try(client_authentication.value.tls, null)
              }
            }
          }
        }
      }
    }

    instance_type   = var.broker_node_instance_type
    security_groups = var.broker_node_security_groups

    dynamic "storage_info" {
      for_each = length(var.broker_node_storage_info) > 0 ? [var.broker_node_storage_info] : []

      content {
        dynamic "ebs_storage_info" {
          for_each = try([storage_info.value.ebs_storage_info], [])

          content {
            dynamic "provisioned_throughput" {
              for_each = try([ebs_storage_info.value.provisioned_throughput], [])

              content {
                enabled           = try(provisioned_throughput.value.enabled, null)
                volume_throughput = try(provisioned_throughput.value.volume_throughput, null)
              }
            }

            volume_size = try(ebs_storage_info.value.volume_size, 64)
          }
        }
      }
    }
  }

  dynamic "client_authentication" {
    for_each = length(var.client_authentication) > 0 ? [var.client_authentication] : []

    content {
      dynamic "sasl" {
        for_each = try([client_authentication.value.sasl], [])

        content {
          iam   = try(sasl.value.iam, null)
          scram = try(sasl.value.scram, null)
        }
      }

      dynamic "tls" {
        for_each = try([client_authentication.value.tls], [])

        content {
          certificate_authority_arns = try(tls.value.certificate_authority_arns, null)
        }
      }

      unauthenticated = try(client_authentication.value.unauthenticated, null)
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

  logging_info {
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

  storage_mode = var.storage_mode

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
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
  security_groups    = each.value.security_groups
  target_cluster_arn = aws_msk_cluster.this[0].arn
  vpc_id             = each.value.vpc_id

  tags = merge(var.tags, try(each.value.tags, {}))
}

################################################################################
# Cluster Policy
################################################################################

resource "aws_msk_cluster_policy" "this" {
  count = var.create && var.create_cluster_policy ? 1 : 0

  cluster_arn = aws_msk_cluster.this[0].arn
  policy      = data.aws_iam_policy_document.this[0].json
}

data "aws_iam_policy_document" "this" {
  count = var.create && var.create_cluster_policy ? 1 : 0

  source_policy_documents   = var.cluster_source_policy_documents
  override_policy_documents = var.cluster_override_policy_documents

  dynamic "statement" {
    for_each = var.cluster_policy_statements

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, [aws_msk_cluster.this[0].arn])
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

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

  byte_length = 8
}

resource "aws_msk_configuration" "this" {
  count = var.create && var.create_configuration ? 1 : 0

  name              = format("%s-%s", coalesce(var.configuration_name, var.name), random_id.this[0].dec)
  description       = var.configuration_description
  kafka_versions    = [var.kafka_version]
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

  tags = var.tags
}

################################################################################
# Storage Autoscaling
################################################################################

resource "aws_appautoscaling_target" "this" {
  count = var.create && var.enable_storage_autoscaling ? 1 : 0

  max_capacity       = var.scaling_max_capacity
  min_capacity       = 1
  role_arn           = var.scaling_role_arn
  resource_id        = aws_msk_cluster.this[0].arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}

resource "aws_appautoscaling_policy" "this" {
  count = var.create && var.enable_storage_autoscaling ? 1 : 0

  name               = "${var.name}-broker-storage-scaling"
  policy_type        = "TargetTrackingScaling"
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
  description   = try(each.value.description, null)

  tags = merge(var.tags, try(each.value.tags, {}))
}

resource "aws_glue_schema" "this" {
  for_each = { for k, v in var.schemas : k => v if var.create && var.create_schema_registry }

  schema_name       = each.value.schema_name
  description       = try(each.value.description, null)
  registry_arn      = aws_glue_registry.this[each.value.schema_registry_name].arn
  data_format       = "AVRO"
  compatibility     = each.value.compatibility
  schema_definition = each.value.schema_definition

  tags = merge(var.tags, try(each.value.tags, {}))
}
