module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "reverse-ssh-vpc"
  vpc_project    = "reverse-ssh"
}

module "gateway" {
  source          = "./modules/gateway"
  gateway_name    = "reverse-ssh-gateway"
  gateway_project = "reverse-ssh"
  vpc_id          = "${module.vpc.id}"
}

module "subnet" {
  source            = "./modules/subnet"
  availability_zone = "${lookup(var.availability_zone,"primary")}"
  public_cidr_block = "10.0.128.0/20"
  gateway_id        = "${module.gateway.id}"
  vpc_id            = "${module.vpc.id}"
  project_name      = "reverse-ssh"
}

module "keypair" {
  source     = "./modules/keypair"
  key_name   = "terraform"
  public_key = "${file("keys/ami_keys.pub")}"
}

module "ssh-instance" {
  source            = "./modules/ec2"
  availability_zone = "${lookup(var.availability_zone,"primary")}"
  ami               = "${lookup(var.amazon_amis,"${var.region}")}"
  instance_type     = "t2.micro"
  user_data         = "${data.template_file.user_data.rendered}"
  subnet            = "${module.subnet.id}"
  security_groups   = "${aws_security_group.default.id}"
  key_name          = "${module.keypair.id}"
  key_file          = "${module.keypair.public_key}"
  tag_name          = "ssh-instance"
}

data "template_file" "user_data" {
  template = "${file("config/cloud-config.yml")}"
}
