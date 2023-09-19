#-----------------------> VPC vars <-----------------------#

variable "cidr_block" {
    type = string
    default = "10.0.0.0/16" 
}

#--------------------> Subnet vars <-----------------------#


variable "cidr_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
variable "subnet-name" {
    type  = list(string)
    default = ["private_subnet-1", "private_subnet-2", "private_subnet-3", "public_subnet-1", "public_subnet-2", "public_subnet-3"]
}

variable "az" {
    type = list(string)
    default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
}

#-----------------------> RT vars <------------------------#

variable "igw_cidr_block" {
    type = string
    default = "0.0.0.0/0"
}
