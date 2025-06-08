```terraform
# Define provider
provider "aws" {
  region = "us-east-1"
}

# Define risk-engine service (dependency for pix and transaction-credit-auth)
resource "aws_ecs_service" "risk_engine" {
  name            = "risk-engine"
  cluster         = "microservices-cluster"
  task_definition = aws_ecs_task_definition.risk_engine.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-12345678"]
    security_groups = ["sg-12345678"]
    assign_public_ip = true
  }

  lifecycle {
    create_before_destroy = true
    # Ephemeral - will be destroyed after 4 hours
    ignore_changes = []
  }

  # Set TTL for ephemeral service
  provisioner "local-exec" {
    command = "sleep 14400 && aws ecs update-service --cluster microservices-cluster --service risk-engine --desired-count 0"
  }
}

resource "aws_ecs_task_definition" "risk_engine" {
  family                   = "risk-engine"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "risk-engine"
      image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/risk-engine:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}

# Define authentication service (dependency for credit-card)
resource "aws_ecs_service" "authentication" {
  name            = "authentication"
  cluster         = "microservices-cluster"
  task_definition = aws_ecs_task_definition.authentication.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-12345678"]
    security_groups = ["sg-12345678"]
    assign_public_ip = true
  }

  lifecycle {
    create_before_destroy = true
    # Ephemeral - will be destroyed after 4 hours
    ignore_changes = []
  }

  # Set TTL for ephemeral service
  provisioner "local-exec" {
    command = "sleep 14400 && aws ecs update-service --cluster microservices-cluster --service authentication --desired-count 0"
  }
}

resource "aws_ecs_task_definition" "authentication" {
  family                   = "authentication"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "authentication"
      image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/authentication:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}

# Define transaction-credit-auth service (depends on risk-engine)
resource "aws_ecs_service" "transaction_credit_auth" {
  name            = "transaction-credit-auth"
  cluster         = "microservices-cluster"
  task_definition = aws_ecs_task_definition.transaction_credit_auth.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on      = [aws_ecs_service.risk_engine]

  network_configuration {
    subnets         = ["subnet-12345678"]
    security_groups = ["sg-12345678"]
    assign_public_ip = true
  }

  lifecycle {
    create_before_destroy = true
    # Ephemeral - will be destroyed after 4 hours
    ignore_changes = []
  }

  # Set TTL for ephemeral service
  provisioner "local-exec" {
    command = "sleep 14400 && aws ecs update-service --cluster microservices-cluster --service transaction-credit-auth --desired-count 0"
  }
}

resource "aws_ecs_task_definition" "transaction_credit_auth" {
  family                   = "transaction-credit-auth"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "transaction-credit-auth"
      image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/transaction-credit-auth:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ],
      environment = [
        {
          name  = "RISK_ENGINE_URL",
          value = "http://risk-engine:8080"
        }
      ]
    }
  ])
}

# Define pix service (depends on risk-engine)
resource "aws_ecs_service" "pix" {
  name            = "pix"
  cluster         = "microservices-cluster"
  task_definition = aws_ecs_task_definition.pix.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on      = [aws_ecs_service.risk_engine]

  network_configuration {
    subnets         = ["subnet-12345678"]
    security_groups = ["sg-12345678"]
    assign_public_ip = true
  }

  lifecycle {
    create_before_destroy = true
    # Ephemeral - will be destroyed after 4 hours
    ignore_changes = []
  }

  # Set TTL for ephemeral service
  provisioner "local-exec" {
    command = "sleep 14400 && aws ecs update-service --cluster microservices-cluster --service pix --desired-count 0"
  }
}

resource "aws_ecs_task_definition" "pix" {
  family                   = "pix"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "pix"
      image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/pix:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ],
      environment = [
        {
          name  = "RISK_ENGINE_URL",
          value = "http://risk-engine:8080"
        }
      ]
    }
  ])
}

# Define credit-card service (depends on authentication and transaction-credit-auth)
resource "aws_ecs_service" "credit_card" {
  name            = "credit-card"
  cluster         = "microservices-cluster"
  task_definition = aws_ecs_task_definition.credit_card.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on      = [aws_ecs_service.authentication, aws_ecs_service.transaction_credit_auth]

  network_configuration {
    subnets         = ["subnet-12345678"]
    security_groups = ["sg-12345678"]
    assign_public_ip = true
  }

  lifecycle {
    create_before_destroy = true
    # Ephemeral - will be destroyed after 4 hours
    ignore_changes = []
  }

  # Set TTL for ephemeral service
  provisioner "local-exec" {
    command = "sleep 14400 && aws ecs update-service --cluster microservices-cluster --service credit-card --desired-count 0"
  }
}

resource "aws_ecs_task_definition" "credit_card" {
  family                   = "credit-card"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "credit-card"
      image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/credit-card:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ],
      environment = [
        {
          name  = "AUTH_SERVICE_URL",
          value = "http://authentication:8080"
        },
        {
          name  = "TRANSACTION_CREDIT_AUTH_URL",
          value = "http://transaction-credit-auth:8080"
        }
      ]
    }
  ])
}
```
