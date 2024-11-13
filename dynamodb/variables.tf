variable "service_name" {
  type        = string
  description = "The name of the service used as part of the DynamoDB table name."
}

variable "hash" {
  type = object({
    key  = string,
    type = string
  })
  description = "Defines the hash key for the DynamoDB table, including the key name and type."
}

variable "range" {
  type = object({
    key  = string,
    type = string
  })
  description = "Optional range key definition for the DynamoDB table, with the key name and type. Set to null if no range key is required."
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
  description = "Additional non-key attributes to include in the table schema, specified as a list of objects with key names and types."
  default     = []
}

variable "stream_enabled" {
  type        = bool
  description = "Enables DynamoDB Streams for the table when set to true, allowing capture of data changes."
  default     = false
}

variable "global_secondary_indexes" {
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = string
    projection_type    = string
    non_key_attributes = list(string)
  }))
  description = "A list of global secondary indexes to create, with each index specifying name, hash key, range key, projection type, and non-key attributes."
  default     = []
}

variable "local_secondary_indexes" {
  type = list(object({
    name               = string
    range_key          = string
    projection_type    = string
    non_key_attributes = list(string)
  }))
  description = "A list of local secondary indexes to create, with each index specifying name, range key, projection type, and non-key attributes."
  default     = []
}

variable "ttl" {
  type = list(object({
    enabled        = bool,
    attribute_name = string
  }))
  description = "Defines TTL (Time-to-Live) settings for the table, including a boolean to enable TTL and the attribute name used to store TTL values."
  default     = []

}

variable "unique_name" {
  type        = bool
  description = "Determines if a unique name should be generated for the DynamoDB table using a random identifier."
  default     = false
}

variable "billing_mode" {
  type        = string
  description = "DynamoDB Billing mode. Can be PROVISIONED or PAY_PER_REQUEST"
  default     = "PAY_PER_REQUEST"
}

variable "enable_point_in_time_recovery" {
  type        = bool
  description = "Enable or disable point-in-time recovery for the DynamoDB table."
  default     = false
}

variable "enable_encryption" {
  type        = bool
  description = "Whether server-side encryption is enabled for the DynamoDB table."
  default     = true
}

variable "server_side_encryption_kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key used for server-side encryption of the DynamoDB table."
}