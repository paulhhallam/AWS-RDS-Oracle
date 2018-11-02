### terraform apply \
### terraform apply  ## automatically finds terraform.tfvars AND *.auto.tfvars
### terraform apply -var-file=variables.tfvars
### Terraform will read environment variables in the form of TF_VAR_name

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
  version    = "~> 1.30"
}
###
###
##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

module "OracleRDSdb" {
 source = "terraform-aws-modules/rds/aws"

  identifier = "demodb"

  engine            = "oracle-ee"
  engine_version    = "12.1.0.2.v8"
  instance_class    = "db.t2.micro"
  allocated_storage = 10
  storage_encrypted = false
  license_model     = "bring-your-own-license"

  # Make sure that database name is capitalized, otherwise RDS will try to recreate RDS instance every time
  name                                = "DEMODB"
  username                            = "phh"
  password                            = "Everton01"
  port                                = "1521"
  iam_database_authentication_enabled = false

#  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]
  vpc_security_group_ids = ["sg-a42140ce"]
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_window          = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
 # DB subnet group
  subnet_ids = ["subnet-92e3acfa", "subnet-a4be3ade", "subnet-a806e9e4"]

  # DB parameter group
  family = "oracle-ee-12.1"

  # DB option group
  major_engine_version = "12.1"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "demodb"

  # See here for support character sets https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html
  character_set_name = "AL32UTF8"

}





#resource "aws_eip" "ip" {
#  instance = "${aws_instance.example.id}"
#}


### OUTPUT
output "ami" {
  value = "${lookup(var.amis, var.region)}"
}
##output "ip" {
##  value = "${aws_eip.ip.public_ip}"
##}
## terraform output ip