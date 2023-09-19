#---------------------------------------------------------#
#                           EC2                           #
#---------------------------------------------------------#

resource "aws_instance" "wordpress-ec2" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type_ec2
  key_name      = var.key
  subnet_id     = var.wordpess_subnet
  vpc_security_group_ids = [aws_security_group.wordpress-sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  tags = {
    Name = "wordpress-ec2"
  }
  user_data = file("modules/Wordpress/user-data.sh")
}

#---------------------------------------------------------#
#                           DB                            #
#---------------------------------------------------------#

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.rds_subnet
  tags = {
    Name = "DB_Subnet_Group"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = var.instance_class_db
  username             = "admin"
  password             = "adminadmin"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot     = false
  identifier = "db-1"
  final_snapshot_identifier = "db-1-snapshot"
  tags = {
    Name = "mysql"
  }
}
#---------------------------------------------------------#
#                Security Groups (EC2/DB)                 #
#---------------------------------------------------------#

#-----------------------> EC2 SG <------------------------#

resource "aws_security_group" "wordpress-sg" {
  name        = "wordpress-sg"
  description = "sgs for HTTP, HTTPS, SSH and MySQL"
  vpc_id = var.vpc_id
  tags = {
    Name = "wordpress-sg"
  }

  dynamic "ingress" {
    for_each = var.ports

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.ports

    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
      description = egress.value.description
    }
  }
}

#-----------------------> RDS SG <------------------------#

resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Security group for MySQL rds"
  vpc_id = var.vpc_id
  tags = {
    Name = "rds-sg"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.wordpress-sg.id]
  }
}
#---------------------------------------------------------#
#            EC2 IAM role to describe db                  #
#---------------------------------------------------------#

resource "aws_iam_role" "ec2_rds_describe_role" {
  name = "EC2_RDS_Describe_Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        
      }
    ]
  })
}

resource "aws_iam_policy" "rds_describe_policy" {
  name = "RDS_Describe_Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "rds:DescribeDBInstances"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfileExample"
  role = aws_iam_role.ec2_rds_describe_role.name
}
resource "aws_iam_role_policy_attachment" "rds_describe_attachment" {
  policy_arn = aws_iam_policy.rds_describe_policy.arn
  role       = aws_iam_role.ec2_rds_describe_role.name
}