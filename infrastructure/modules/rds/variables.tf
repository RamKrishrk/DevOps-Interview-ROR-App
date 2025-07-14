variable "project_name" {}
variable "db_username" {}
variable "db_password" {}
variable "db_name" {
  default = "ror_db"
}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}

