resource "aws_dynamodb_table" "this" {
  name = local.db_name

  billing_mode     = var.billing_mode
  hash_key         = var.hash.key
  range_key        = var.range.key
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_enabled ? "NEW_AND_OLD_IMAGES" : null

  dynamic "attribute" {
    for_each = local.attributes
    content {
      name = attribute.value.key
      type = attribute.value.type
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      non_key_attributes = local_secondary_index.value.non_key_attributes
      projection_type    = local_secondary_index.value.projection_type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      non_key_attributes = global_secondary_index.value.non_key_attributes
      projection_type    = global_secondary_index.value.projection_type
    }
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  dynamic "ttl" {
    for_each = var.ttl
    content {
      enabled        = ttl.value.enabled
      attribute_name = ttl.value.attribute_name
    }
  }
}

resource "random_id" "this" {
  byte_length = 8
  prefix      = "${var.service_name}-"
}

locals {
  attributes = concat(
    [
      {
        name = var.range.key
        type = var.range.type
      },
      {
        name = var.hash_.ey
        type = var.hash.type
      }
    ],
    var.additional_attributes
  )

  db_name = "cvs-${terraform.workspace}-${var.unique_name ? random_id.this.hex : var.service_name}"
}