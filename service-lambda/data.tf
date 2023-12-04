data "aws_lambda_function" "template_lambda" {
  function_name = "${var.scaffold_from}"
}

data "aws_iam_policy_document" "assumerole" {
  statement {
    sid     = "AllowLambdaAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_s3_object" "service_hash" {
  bucket = var.bucket_name
  key    = "${var.bucket_key}/latestHash_${terraform.workspace}.txt"
}

data "aws_s3_object" "service" {
  bucket = var.bucket_name
  key    = "${var.bucket_key}/${data.aws_s3_object.service_hash.body}.zip"
}