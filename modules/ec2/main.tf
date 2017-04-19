variable "availability_zone" {}
variable "ami" {}
variable "user_data" {}
variable "subnet" {}
variable "security_groups" {}
variable "key_file" {}
variable "key_name" {}
variable "tag_name" {}
variable "instance_type" {}

resource "aws_instance" "ssh-instance" {
  connection {
    user     = "ec2-user"
    key_file = "${var.key_file}"
  }

  availability_zone = "${var.availability_zone}"
  ami               = "${var.ami}"
  instance_type     = "${var.instance_type}"
  user_data         = "${var.user_data}"
  subnet_id         = "${var.subnet}"
  security_groups   = ["${var.security_groups}"]
  key_name          = "${var.key_name}"

  tags {
    Name = "${var.tag_name}"
  }
}

resource "aws_eip" "ssh-instance-eip" {
  depends_on = ["aws_instance.ssh-instance"]
  instance   = "${aws_instance.ssh-instance.id}"
  vpc        = true
}

output "id" {
  value = "${aws_instance.ssh-instance.id}"
}

output "ip" {
  value = "${aws_eip.ssh-instance-eip.public_ip}"
}
