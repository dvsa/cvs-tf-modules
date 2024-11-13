# cvs-tf-modules
A repository to contain the modules required to build components of the CVS architecture in AWS

## Usage

To read a Module from this repository, the current definition should follow this example@

```json
module "iam_role" {
  for_each = local.roles
  source = "git::https://github.com/dvsa/cvs-tf-modules//iam_role"
  name = each.key
  description = each.key
  region = var.AWS_REGION
  environment = var.AWS_ENVIRONMENT
  assume_policy = templatefile("${path.root}/data/assume_role.json.tpl", {
    Account = local.aws_accounts[var.management_env].id
    Region = var.AWS_REGION
  })
  iam_policy = templatefile("${path.root}/${each.value}", {
    Account = local.aws_accounts[var.AWS_ENVIRONMENT].id
    Region = var.AWS_REGION
  })
}
```

When developing the module, the feature branch can be accessed by using the `ref` parameter:

```json
  source = "git::https://github.com/dvsa/cvs-tf-modules//iam_role?ref=feature/CB2-14861"
```