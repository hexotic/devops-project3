variable "ami" {
  default = "ami-04505e74c0741db8d"
  type    = string
}
variable "instance_type" {
  default = "t2.small"
  type    = string
}

variable "user_name" {
  default = "Django-app"
  type    = string
}

variable "sg_name" {
  default = "christophe-sg-web"
  type    = string
}
variable "key_name" {
  default = "christophe-kp"
  type    = string
}

variable "env" {
  default = ""
  type    = string
}

variable "user_passwd" {
  default = ""
  type    = string
}

 