variable "availability_zone" {}
variable "public_cidr_block" {}
variable "vpc_id" {}
variable "project_name" {}
variable "gateway_id" {}

resource "aws_subnet" "public-One" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.public_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.availability_zone}"

  tags {
    Name    = "Public Subnet"
    Project = "${var.project_name}"
  }
}

resource "aws_route_table" "public-One-Route" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.gateway_id}"
  }

  tags {
    Name    = "Public Route Table"
    Project = "${var.project_name}"
  }
}

resource "aws_route_table_association" "public-Assoc-One" {
  subnet_id      = "${aws_subnet.public-One.id}"
  route_table_id = "${aws_route_table.public-One-Route.id}"
}

output "id" {
  value = "${aws_subnet.public-One.id}"
}
