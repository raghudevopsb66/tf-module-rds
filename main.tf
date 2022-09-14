resource "aws_docdb_cluster" "main" {
  cluster_identifier              = "${var.env}-docdb"
  engine                          = "docdb"
  engine_version                  = var.engine_version
  master_username                 = local.username
  master_password                 = local.password
  skip_final_snapshot             = true
  db_subnet_group_name            = aws_docdb_subnet_group.main.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name
  vpc_security_group_ids          = [aws_security_group.main.id]
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "${var.env}-docdb-${count.index}"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = var.instance_class
}

resource "aws_docdb_subnet_group" "main" {
  name       = "${var.env}-docdb"
  subnet_ids = var.apps_subnets_ids

  tags = {
    Name = "${var.env}-docdb"
  }
}

resource "aws_docdb_cluster_parameter_group" "main" {
  family      = "docdb4.0"
  name        = "${var.env}-docdb"
  description = "${var.env}-docdb"
}

resource "aws_security_group" "main" {
  name        = "${var.env}-docdb"
  description = "${var.env}-docdb"
  vpc_id      = var.vpc_id

  ingress {
    description = "DOCUMENTDB"
    from_port   = 27107
    to_port     = 27107
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
  tags = {
    Name = "${var.env}-docdb"
  }
}

