#-----------------------> EC2 vars <----------------------#

variable "vpc_id" {
  type = string
}
variable "wordpess_subnet" {
    type = string  
}

variable "instance_type_ec2" {
    type = string
    default = "t2.micro"
}
variable "key" {
    type = string
}

#------------------------> DB vars <----------------------#

variable "rds_subnet" {
  type = list(string)  
}
variable "instance_class_db" {
    type = string  
    default = "db.t2.micro"
}

#-----------------------> SGS vars <----------------------#

variable "ports" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))
  default = {
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
    }
    https = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
    }
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
    }
    mysql = {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL"
    }
  }
}
