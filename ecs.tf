resource "aws_security_group" "wordpress-sg" {
  vpc_id = aws_vpc.main-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "mysql-sg" {
  vpc_id = aws_vpc.main-vpc.id

  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    security_groups   = [aws_security_group.wordpress-sg.id]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_ecs_cluster" "wordpress_cluster" {
  name = "${var.resource-name}-wordpress-cluster"
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "aqeelecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



resource "aws_ecs_task_definition" "mysql" {
  family                   = "mysql-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "mysql"
      image     = "mysql:5.7"
      essential = true
      environment = [
        {
          name  = "MYSQL_ROOT_PASSWORD"
          value = "aqeel123"
        },
        {
          name  = "MYSQL_DATABASE"
          value = "mydb"
        },
        {
          name  = "MYSQL_USER"
          value = "aqeel"
        },
        {
          name  = "MYSQL_PASSWORD"
          value = "aqeel123"
        },
      ]
      portMappings = [
        {
          containerPort = 3306
          protocol = "tcp"
          hostPort      = 3306
        },
      ]
    },
  ])
}


resource "aws_ecs_task_definition" "wordpress" {
  family                   = "wordpress-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "wordpress"
      image     = "wordpress:latest"
      essential = true
      environment = [
        {
          name  = "DB_HOST"
          value = "mysql:3306"
        },
        {
          name  = "DB_USER"
          value = "aqeel"
        },
        {
          name  = "DB_PASSWORD"
          value = "aqeel123"
        },
        {
          name  = "DB_NAME"
          value = "mydb"
        },
      ]
      portMappings = [
        {
          containerPort = 80
          protocol = "tcp"
          hostPort = 80
        },
      ]
    },
  ])
}

resource "aws_ecs_service" "mysql_service" {
  name            = "mysql-service"
  cluster         = aws_ecs_cluster.wordpress_cluster.id
  task_definition = aws_ecs_task_definition.mysql.arn
  scheduling_strategy = "REPLICA"
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on      = [aws_iam_role.ecs_task_execution_role]

  network_configuration {
    subnets          = aws_subnet.pri-subnet1.*.id           
    security_groups  = [aws_security_group.mysql-sg.id]
    assign_public_ip = false
  }
}



resource "aws_ecs_service" "wordpress_service" {
  name            = "wordpress-service"
  cluster         = aws_ecs_cluster.wordpress_cluster.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  scheduling_strategy = "REPLICA"
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on      = [aws_iam_role.ecs_task_execution_role]

  network_configuration {
    subnets          = [aws_subnet.pub-subnet1[0].id, aws_subnet.pub-subnet1[1].id]
    security_groups  = [aws_security_group.wordpress-sg.id]
    assign_public_ip = true
  }
}