cidr = "192.168.0.0/16"
cidr_sub1 = "192.168.1.0/24"
cidr_sub2 = "192.168.2.0/24"
cidr_route = "0.0.0.0/0"

availability_zone1 = "us-east-2a"
availability_zone2 = "us-east-2b"

name = "web-sg"

instance_type = "t3.micro"
ami_id = "ami-04f2ba315f7ebb999"

bucket_name = "terraform-s3-test-project-2024"

alb_name = "webMyALB"

mylb = "myTG"
