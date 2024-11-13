locals {
  hash_attr = [{
    name = var.hash.key
    type = var.hash.type
  }]
  
  range_attr = var.range != null ? [{
    name = var.range.key
    type = var.range.type
  }] : []
  
  attributes = concat(local.hash_attr, local.range_attr, var.additional_attributes)

  db_name = "cvs-${terraform.workspace}-${var.unique_name ? random_id.reference_data_unique_identifier.hex : var.service_name}"
}

resource "aws_dynamodb_table" "db" {
  name = local.db_name

  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = var.hash.key
  range_key        = var.range.key
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_enabled ? "NEW_AND_OLD_IMAGES" : null

  dynamic "attribute" {
    for_each = local.attributes
    content {
      name = attribute.value["key"]
      type = attribute.value["type"]
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

  dynamic "point_in_time_recovery" {
    for_each = terraform.workspace == "prod" ? {
      enabled : true
    } : {}
    content {
      enabled = true
    }
  }

  dynamic "ttl" {
    for_each = var.ttl
    content {
      enabled        = ttl.value.enabled
      attribute_name = ttl.value.attribute_name
    }
  }

  tags = {
    Environment = terraform.workspace
  }
}

resource "random_id" "reference_data_unique_identifier" {
  byte_length = 8
  prefix      = "${var.service_name}-"
}