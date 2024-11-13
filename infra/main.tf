terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.74.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# Define the SQS queue
resource "aws_sqs_queue" "image_request_queue" {
  name                     = "image_request_queue_54" 
  visibility_timeout_seconds = 70 
}

# Define the IAM Role
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role_54"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

# Define the Bedrock Full Access Policy
resource "aws_iam_policy" "bedrock_full_access_policy" {
  name = "BedrockFullAccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "bedrock:*",
        Resource = "*"
      }
    ]
  })
}

# Define the S3 Full Access Policy
resource "aws_iam_policy" "s3_full_access_policy" {
  name = "S3FullAccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::pgr301-couch-explorers",
          "arn:aws:s3:::pgr301-couch-explorers/*"
        ]
      }
    ]
  })
}

# Define the SQS Access Policy for Lambda
resource "aws_iam_policy" "lambda_sqs_access_policy" {
  name = "LambdaSQSPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = aws_sqs_queue.image_request_queue.arn
      }
    ]
  })
}

# Attach policies to the Lambda role
resource "aws_iam_role_policy_attachment" "attach_bedrock_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.bedrock_full_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.s3_full_access_policy.arn
}

# Attach SQS Access Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "attach_sqs_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_sqs_access_policy.arn
}

# Attach AWSLambdaBasicExecutionRole for CloudWatch logging permissions
resource "aws_iam_role_policy_attachment" "lambda_execution_basic_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Define the Lambda function
resource "aws_lambda_function" "process_image_request" {
  function_name = "process_image_request_54"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "image_processor.lambda_handler"
  runtime       = "python3.9"
  memory_size   = 256
  timeout       = 60

  environment {
    variables = {
      BUCKET_NAME     = "pgr301-couch-explorers"
      CANDIDATE_NUMBER = "54"
    }
  }

  # Zip package path
  filename = "${path.module}/deployment_package.zip"
}

# SQS to Lambda trigger
resource "aws_lambda_event_source_mapping" "sqs_lambda_trigger" {
  event_source_arn = aws_sqs_queue.image_request_queue.arn
  function_name    = aws_lambda_function.process_image_request.arn
  batch_size       = 10
}