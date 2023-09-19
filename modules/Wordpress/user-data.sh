#!/bin/bash
# Install required packages
yum update -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2 
yum install -y httpd

# Download and configure WordPress

cd /var/www/html/
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/wordpress

# Edit the config.txt file
sleep 240
cd /var/www/html/
mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i '23s/database_name_here/mysql/' wp-config.php
sed -i '26s/username_here/admin/' wp-config.php
sed -i '29s/password_here/adminadmin/' wp-config.php
# create a VAR that assumes RDS endpoint value. Also IAM role rds describe is required. 
RDS_ENDPOINT=$(aws rds describe-db-instances --region us-east-1 --query "DBInstances[0].Endpoint.Address" --output text)
CONFIG_LINE="define( 'DB_HOST', '$RDS_ENDPOINT' );"
sed -i "32s/.*/$CONFIG_LINE/" wp-config.php

# Restart Apache
systemctl restart httpd