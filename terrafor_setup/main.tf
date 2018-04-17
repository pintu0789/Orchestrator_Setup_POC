provider "aws" {
region = "ap-southeast-1"
access_key=""
secret_key=""
}


resource "aws_instance" "ec2_instance_master" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.master_instance_type}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.master_security_group.id}"]
  key_name               = "${var.key_name}"
  # metadata tagging
  tags {
      Name               = "mysql-prod-master"
      pod                = "${var.pod}"
      env                = "${var.env}"
  }
}

resource "aws_instance" "ec2_instance_slave1" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.slave_instance_type}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.slave_security_group.id}"]
  key_name               = "${var.key_name}"
  # metadata tagging
  tags {
      Name               = "mysql-prod-slave1"
      pod                = "${var.pod}"
      env                = "${var.env}"
  }
}

resource "aws_instance" "ec2_instance_slave2" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.slave_instance_type}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.slave_security_group.id}"]
  key_name               = "${var.key_name}"
  # metadata tagging
  tags {
      Name               = "mysql-prod-slave2"
      pod                = "${var.pod}"
      env                = "${var.env}"
  }
}


resource "aws_instance" "ec2_instance_controller" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.controller_instance_type}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.slave_security_group.id}"]
  key_name               = "${var.key_name}"
  # metadata tagging
  tags {
      Name               = "mysql-prod-controller"
      pod                = "${var.pod}"
      env                = "${var.env}"
  }
}


resource "aws_security_group" "master_security_group" {
  name        = "${var.pod}_${var.env}_mysql_master_security_group"
  description = "aws security group for mysql master"
  vpc_id      = "${var.vpc_id}"
    #allow SSH connectivity
  #allow https access to vpc
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["182.75.181.110/32"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.31.0.0/16"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["52.221.63.6/32"]
  }
    #allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name        = "${var.pod}_${var.env}_mysql_master_security_group"
    env         = "${var.env}"
    pod         = "${var.pod}"
  }
}

resource "aws_security_group" "slave_security_group" {
  name        = "${var.pod}_${var.env}_mysql_slave_security_group"
  description = "aws security group for mysql slave"
  vpc_id      = "${var.vpc_id}"
    #allow SSH connectivity
  #allow https access to vpc
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["182.75.181.110/32"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.31.0.0/16"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["52.221.63.6/32"]
  }
    #allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name        = "${var.pod}_${var.env}_mysql_slave_security_group"
    env         = "${var.env}"
    pod         = "${var.pod}"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = [""] # Canonical
}
