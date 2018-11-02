variable "region" {default = "us-east-2"}
variable "aws_instance_type" {
    default = "t2.micro"
}
variable "amis" {
  type = "map"
   default = {
    "us-east-1" = "ami-b374d5a5"
	"us-east-2" = "ami-5e8bb23b"
    "us-west-2" = "ami-4b32be2b"
  } 
}