#-------------------------> EC2 <-------------------------#

output "public_dns" {
  value = aws_instance.wordpress-ec2.public_dns
} 
#-------------------------> Roles <-----------------------#

output "iam_instance_profile" {
    value = aws_iam_instance_profile.ec2_instance_profile.name  
}
#-------------------------> SGS <-------------------------#

output "rds_sg" {
    value = aws_security_group.rds-sg.id  
}
output "ec2_sg" {
    value = aws_security_group.wordpress-sg.id
}