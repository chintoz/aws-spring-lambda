
resource "aws_s3_object" "spring_lambda_jar" {
  bucket = aws_s3_bucket.spring_lambda_bucket.bucket
  key    = "target/my-service-1.0-SNAPSHOT-lambda-package.zip"
  source = "../target/my-service-1.0-SNAPSHOT-lambda-package.zip"
  depends_on = [aws_s3_bucket.spring_lambda_bucket]
}

resource "aws_lambda_function" "spring_lambda" {
  function_name = "SpringLambda"

  s3_bucket = aws_s3_bucket.spring_lambda_bucket.bucket
  s3_key    = "target/my-service-1.0-SNAPSHOT-lambda-package.zip"

  handler = "es.menasoft.lambda.StreamLambdaHandler::handleRequest"
  runtime = "java21"

  role = aws_iam_role.lambda_exec_role.arn

  reserved_concurrent_executions = 5

  snap_start {
    apply_on = "PublishedVersions"
  }

  depends_on = [aws_s3_object.spring_lambda_jar]
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::123456789012:saml-provider/YOUR_SAML_PROVIDER_NAME"
        }
        Action = "sts:AssumeRoleWithSAML"
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
}

output "lambda_function_name" {
  value = aws_lambda_function.spring_lambda.function_name
}