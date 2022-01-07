################################################################################
# Connect Custom Plugin
################################################################################

resource "aws_mskconnect_custom_plugin" "this" {
  for_each = { for k, v in var.connect_custom_plugins : k => v if var.create }

  name         = each.value.name
  description  = lookup(each.value, "description", null)
  content_type = each.value.content_type

  location {
    s3 {
      bucket_arn     = each.value.s3_bucket_arn
      file_key       = each.value.s3_file_key
      object_version = lookup(each.value, "s3_object_version", null)
    }
  }

  timeouts {
    create = try(each.value.timeouts.create, var.connect_custom_plugin_timeouts.create, null)
  }
}

################################################################################
# Connect Worker Configuration
################################################################################

resource "aws_mskconnect_worker_configuration" "this" {
  count = var.create && var.create_connect_worker_configuration ? 1 : 0

  name                    = var.connect_worker_config_name
  description             = var.connect_worker_config_description
  properties_file_content = var.connect_worker_config_properties_file_content
}
