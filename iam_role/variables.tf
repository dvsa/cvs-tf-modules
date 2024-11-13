# Create IAM Role Module
variable "region" {
  type        = string
  description = "AWS Region of the IAM Role being created"
}

variable "environment" {
  type        = string
  description = "AWS Environment of the IAM Role being created"
}

variable "name" {
  type        = string
  description = "Name of the IAM Role being created"
}

variable "description" {
  type        = string
  description = "Description for the IAM Role being created"
}

variable "assume_policy" {
  type        = string
  description = "Assume Role Policy for the IAM Role being created"
}

variable "iam_policy" {
  type        = string
  description = "IAM Policy for the IAM Role being created"
}

variable "path" {
  type        = string
  description = "Path for the IAM Role being created"
  default     = "/"
}

