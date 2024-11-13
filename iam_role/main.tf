# Create IAM Role Module
resource "aws_iam_role" "this" {
  name = format("%s-%s-%s", local.name, var.environment, var.region)
  assume_role_policy = var.assume_policy
}

resource "aws_iam_policy" "this" {
  name = format("%s-policy-%s-%s", local.name, var.environment, var.region)
  path = var.path
  description = var.description
  policy = var.iam_policy
}

resource "aws_iam_policy_attachment" "this" {
  name = format("%s-%s-%s", local.name, var.environment, var.region)
  roles = [aws_iam_role.this.arn]
  policy_arn = aws_iam_policy.this.arn
}

locals {
  name = replace(var.name, "_", "-")
}