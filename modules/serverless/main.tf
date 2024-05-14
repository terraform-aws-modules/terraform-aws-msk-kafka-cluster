################################################################################
# Serverless Cluster
################################################################################
resource "aws_msk_serverless_cluster" "this" {
  count = var.create ? 1 : 0

  client_authentication {
    sasl {
      iam {
        enabled = true
      }
    }
  }

  cluster_name = var.name

  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }

  tags = var.tags
}

################################################################################
# Cluster Policy
################################################################################

resource "aws_msk_cluster_policy" "this" {
  count = var.create && var.create_cluster_policy ? 1 : 0

  cluster_arn = aws_msk_serverless_cluster.this[0].arn
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
      resources     = try(statement.value.resources, [aws_msk_serverless_cluster.this[0].arn])
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
