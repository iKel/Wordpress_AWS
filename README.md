![enter image description here](https://kinsta.com/wp-content/uploads/2017/12/wordpress-admin.png)
## WordPress via Terraform deployed on AWS

  Fully automated WordPress deployment on AWS. Written in Terraform.
___
Consists of two modules:
 - VPC is responsible for VPC configurations such as subnets, route tables, and connection configuration. 
 - WordPress is responsible for deploying WordPress. It consists of EC2, RDS database, security groups, and IAM Roles. WordPress is installed on EC2 using a user-data script. 

WordPress could be simply accessed by running: `terraform apply —auto-approve`
___
Helpful resources:

-   [Deploy WordPress with Amazon RDS](https://aws.amazon.com/getting-started/hands-on/deploy-wordpress-with-amazon-rds/)
-   [EC2 LAMP Amazon Linux 2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-lamp-amazon-linux-2.html)
