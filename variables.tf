variable "cidr" {
type = string
description = "This is cidr"
default = ""
}
variable "cidr_sub1" {
type = string
description = "This is cidr for subnet1"
default = ""
}
variable "cidr_sub2" {
type = string
description = "This is cidr for subnet2"
default = ""
}
variable "cidr_route" {
type = string
description = "This is cidr for rules inbound"
default = ""
}
variable "name" {}

variable "availability_zone1" {
type = string
description = "This is availability zone1"
default = ""
}
variable "availability_zone2" {
type = string
description = "This is availability zone2"
default = ""
}
variable "instance_type" {
type = string
description = "This is instance type"
default = ""
}
variable "ami_id" {
type = string
description = "This is ami id"
default = ""
}
variable "bucket_name" {
type = string
description = "This is bucket name"
default = ""
}
variable "alb_name" {}
variable "mylb" {}

