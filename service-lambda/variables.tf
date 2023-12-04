variable "service_name" {
  description = "Service name e.g. defects"
  type        = string
  default     = ""
}

variable "handler" {
  description = "The lambda handler entry point"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the service lambda (workspace will be appended)"
  type        = string
  default     = ""
}

variable "component" {
  description = "Service component e.g. dft"
  type        = string
  default     = ""
}

variable "project" {
  type        = string
  description = "The name of the tfscaffold project"
  default     = "cvs"
}

variable "invoker_arn" {
  type        = string
  description = "The arn of the service that can invoke this lambda"
  default     = ""
}

variable "bucket_name" {
  type        = string
  description = "The bucket name this service is persisted"
  default     = "cvs-services"
}

variable "bucket_key" {
  type        = string
  description = "The bucket key this service is persisted"
  default     = ""
}

variable "csi" {
  type = string
  description = "CSI for use in resources with a global namespace, i.e. S3 Buckets"
  default = ""
}

variable "scaffold_from" {
  type        = string
  description = "The lambda resource to scaffold the new lambda from"
  default     = "defects-${terraform.workspace}"
}

variable "timeout_alarm_threshold" {
  type    = number
  default = 1
}

variable "timeout_alarm_evaluation_periods" {
  type    = number
  default = 2
}

variable "timeout_alarm_period" {
  type    = number
  default = 60
}

variable "errors_alarm_threshold" {
  type    = number
  default = 1
}

variable "errors_alarm_evaluation_periods" {
  type    = number
  default = 2
}

variable "errors_alarm_period" {
  type    = number
  default = 60
}

variable "log_retention_days" {
  type    = number
  default = 90
}
