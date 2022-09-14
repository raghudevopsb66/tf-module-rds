resource "aws_rds_cluster" "main" {
  cluster_identifier = "${var.env}-rds"
  engine             = "mysql"
  engine_version     = var.engine_version
  database_name      = "dummy"
  master_username    = local.username
  master_password    = local.password
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "${var.env}-rds-${count.index}"
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version
}


resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-rds"
  subnet_ids = var.db_subnets_ids

  tags = {
    Name = "${var.env}-rds"
  }
}

resource "aws_db_parameter_group" "main" {
  family      = "mysql5.7"
  name        = "${var.env}-rds"
  description = "${var.env}-rds"
}

resource "aws_security_group" "main" {
  name        = "${var.env}-rds"
  description = "${var.env}-rds"
  vpc_id      = var.vpc_id

  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
  tags = {
    Name = "${var.env}-rds"
  }
}

