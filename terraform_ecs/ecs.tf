data "aws_ecr_repository" "cohere" {
  name = var.ecr_repository_name
}

resource "aws_ecs_cluster" "cohere_ecs_test" {
    name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "cohere_task_def"{
    family = var.ecs_task_def_name
    container_definitions = jsonencode([
    {
      name      = "container"
      image     = "${data.aws_ecr_repository.cohere.repository_url}"
      cpu       = var.ecs_cpu
      memory    = var.ecs_memory
      essential = true
      portMappings = [
        {
          containerPort = var.backend_port
          hostPort      = var.backend_port
        }
      ]
    },
    ])
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = var.ecs_cpu
    memory = var.ecs_memory
    execution_role_arn = aws_iam_role.cohere_ecs_task_exec_role.arn
    task_role_arn = aws_iam_role.cohere_ecs_task_exec_role.arn
    depends_on = [ aws_iam_role.cohere_ecs_task_exec_role ]
}

resource "aws_ecs_service" "cohere_service"{
    name = var.ecs_service_name
    cluster = aws_ecs_cluster.cohere_ecs_test.id
    task_definition = aws_ecs_task_definition.cohere_task_def.arn
    launch_type = "FARGATE"
    desired_count = var.desired_containers
    health_check_grace_period_seconds = 10
    
    
   network_configuration{
      subnets = [data.aws_subnet.cohere_private_a.id,data.aws_subnet.cohere_private_b.id]
      security_groups = ["${aws_security_group.cohere_ecs_service_sg.id}"]
      assign_public_ip = true
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.cohere_lb_tg.arn
      container_name   = "container"
      container_port   = var.backend_port
  }
}



