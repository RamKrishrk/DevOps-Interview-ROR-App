variable "aws_region" {
  default = "ap-south-1"
}

variable "project_name" {
  default = "ror-nginx-app"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_name" {
  default = "ror_db"
}

variable "ecr_image_url_nginx" {
  type = string
}

variable "ecr_image_url_rails" {
  type = string
}
