variable "service_name" {
  type = string
}

variable "hash" {
  type = object({
    key  = string,
    type = string
  })
}
variable "range" {
  type = object({
    key  = string,
    type = string
  })
  default = {
    key  = null,
    type = null
  }
}

variable "additional_attributes" {
  type = list(object({
    key  = string,
    type = string
  }))
  default = []
}

variable "stream_enabled" {
  type    = bool
  default = false
}

variable "global_secondary_indexes" {
  type = list(object({
    name               = string,
    hash_key           = string
    range_key          = string
    projection_type    = string
    non_key_attributes = list(string)
  }))
  default = []
}

variable "local_secondary_indexes" {
  type = list(object({
    name               = string,
    range_key          = string
    projection_type    = string
    non_key_attributes = list(string)
  }))
  default = []
}

variable "ttl" {
  type = list(object({
    enabled        = bool,
    attribute_name = string
  }))
  default = []
}

variable "unique_name" {
  type    = bool
  default = false
}

variable "billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "DynamoDB Billing mode. Can be PROVISIONED or PAY_PER_REQUEST"
}

variable "enable_point_in_time_recovery" {
  type        = bool
  description = "Enable or disable point-in-time recovery for the DynamoDB table."
  default     = false
}