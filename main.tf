#Creating VPC
resource "aws_vpc" "myvpc" {
cidr_block = var.cidr
}

#Creating Subnet1
resource "aws_subnet" "sub1" {
vpc_id = aws_vpc.myvpc.id
cidr_block = var.cidr_sub1
availability_zone = var.availability_zone1
map_public_ip_on_launch = true
}

#Creating subnet2
resource "aws_subnet" "sub2" {
vpc_id = aws_vpc.myvpc.id
cidr_block = var.cidr_sub2
availability_zone = var.availability_zone2
map_public_ip_on_launch = true
}

#Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.myvpc.id
}

#Creating Route tables
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = var.cidr_route
    gateway_id = aws_internet_gateway.igw.id
  }
}
#Creating subnet association
resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}
#Creating Security Groups
resource "aws_security_group" "webSG" {
  name = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.cidr_route]
  }

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.cidr_route]
  }

  egress {
    description = "Outbound Rules"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.cidr_route]
  }

  tags = {Name = var.name}
}

#Creating S3 Bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket_name
}

#Craeting EC2 Instance with the VPC
resource "aws_instance" "webserver1" {
  ami = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.webSG.id]
  subnet_id = aws_subnet.sub1.id
  user_data = file("userdata.sh")
}
resource "aws_instance" "webserver2" {
  ami = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.webSG.id]
  subnet_id = aws_subnet.sub2.id
  user_data = file("userdata1.sh")
}

#Create ALB
resource "aws_lb" "myalb" {
  name = var.alb_name
  internal = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.webSG.id]
  subnets = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  tags = {Name = var.alb_name}
}

#Create Load Balancer
resource "aws_lb_target_group" "tg" {
  name = var.mylb
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}

output "loadbalancerdns" {
  value = aws_lb.myalb.dns_name
}













