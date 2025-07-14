variable "project_name" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
variable "ecr_image_url_nginx" {}
variable "ecr_image_url_rails" {}
variable "execution_role_arn" {}
variable "rds_endpoint" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "s3_bucket_name" {}
variable "region" {}
variable "target_group_arn" {
  type = string
}

