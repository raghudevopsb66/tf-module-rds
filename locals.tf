locals {
  username = element(split("/", data.aws_ssm_parameter.credentials.value), 0)
  password = element(split("/", data.aws_ssm_parameter.credentials.value), 1)
}
