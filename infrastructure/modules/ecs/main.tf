resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "rails_app"
      image     = var.ecr_image_url_rails
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "RDS_DB_NAME",      value = var.db_name },
        { name = "RDS_USERNAME",     value = var.db_username },
        { name = "RDS_PASSWORD",     value = var.db_password },
        { name = "RDS_HOSTNAME",     value = var.rds_endpoint },
        { name = "RDS_PORT",         value = "5432" },
        { name = "S3_BUCKET_NAME",   value = var.s3_bucket_name },
        { name = "S3_REGION_NAME",   value = var.region },
      ]
    },
    {
      name      = "nginx"
      image     = var.ecr_image_url_nginx
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ],
      #  links = ["rails_app"]
    }
  ])
}

resource "aws_ecs_service" "app_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [aws_ecs_task_definition.app_task]
}

