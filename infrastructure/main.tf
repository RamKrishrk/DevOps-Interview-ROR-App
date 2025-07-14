module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  aws_region   = var.aws_region
}
module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}
module "rds" {
  source       = "./modules/rds"
  project_name = var.project_name

  db_username = var.db_username
  db_password = var.db_password
  db_name     = var.db_name

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
}
module "iam" {
  source         = "./modules/iam"
  project_name   = var.project_name
  s3_bucket_name = module.s3.bucket_name
}
module "ecs" {
  source              = "./modules/ecs"
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.alb.ecs_service_sg_id]
  execution_role_arn  = module.iam.ecs_task_execution_role_arn
  ecr_image_url_nginx = var.ecr_image_url_nginx
  ecr_image_url_rails = var.ecr_image_url_rails

  rds_endpoint     = module.rds.db_endpoint
  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
  s3_bucket_name   = module.s3.bucket_name
  region           = var.aws_region
  target_group_arn = module.alb.target_group_arn
}
module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

