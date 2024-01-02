  variable "service_name" {
  description = "Service name e.g. defects"
  type        = string
  default     = ""
}

variable "open_api_spec_file" {
  description = "The path to the open api spec to generate the api gateway"
  type        = string
  default     = ""
}

variable "project" {
  type        = string
  description = "The name of the tfscaffold project"
  default     = "cvs"
}

variable "component" {
  type        = string
  description = "The name of the tfscaffold component"
  default     = "tf"
}

variable "csi" {
  type = string
  description = "CSI for use in resources with a global namespace, i.e. S3 Buckets"
  default = ""
}

variable "lambdas" {
  type        = map(object({
    service_name = string
    bucket_key = string
    handler = string
    description = string
    environment_variables = optional(map(string))
  }))
  description = "The lambda to associate with this gateway"
}

variable "scaffold_from" {
  type        = string
  description = "The APIG resource to scaffold the new APIG from"
  default     = ""
}