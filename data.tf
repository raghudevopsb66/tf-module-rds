data "aws_ssm_parameter" "credentials" {
  name = "mutable.rds.${var.env}.credentials"
}

