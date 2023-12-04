locals {
  default_iam_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
    "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  accounts_to_allert_in = ["prod", "preprod", "integration", "develop"]
  is_main_env           = contains(local.accounts_to_allert_in, terraform.workspace)

  scaffold_from         = length(var.scaffold_from) > 0 ? var.scaffold_from : "defects-${terraform.workspace}"
}
