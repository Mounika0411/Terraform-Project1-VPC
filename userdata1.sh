#!/bin/bash

# Update system
yum update -y

# Install Apache (httpd)
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Get instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Install AWS CLI (optional but safe)
yum install -y awscli

# (Optional) Download image from S3
# aws s3 cp s3://myterraformprojectbucket2023/project.webp /var/www/html/project.png

# Create HTML page
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>My Portfolio</title>
  <style>
    @keyframes colorChange {
      0% { color: red; }
      50% { color: green; }
      100% { color: blue; }
    }
    h1 {
      animation: colorChange 2s infinite;
    }
  </style>
</head>
<body>
  <h1>Terraform Project Server 2 with second EC2 instance</h1>
  <h2>Instance ID: <span style="color:green">$INSTANCE_ID</span></h2>
  <p>Welcome to Mounika's Terraform Project Demo</p>
</body>
</html>
EOF
