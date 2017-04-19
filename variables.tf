variable "region" {
  default = "eu-west-1"
}

variable "availability_zone" {
  type = "map"

  default = {
    primary = "eu-west-1a"
  }
}

variable "amazon_amis" {
  type = "map"

  default = {
    eu-west-1 = "ami-70edb016"
  }
}
