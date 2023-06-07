data "aws_iam_policy_document" "cohere_assume_role_policy"{
    statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cohere_ecs_task_exec_role"{
    name = "ecs_task_execution_role"
    assume_role_policy = data.aws_iam_policy_document.cohere_assume_role_policy.json
}
resource "aws_iam_role_policy_attachment" "cohere_ecs_tasks_exec_role_attach" {
  role       = aws_iam_role.cohere_ecs_task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}