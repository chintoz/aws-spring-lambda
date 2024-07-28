resource "aws_api_gateway_rest_api" "spring_lambda_api" {
  name        = "SpringLambdaAPI"
  description = "API Gateway for Spring Lambda"
}

resource "aws_api_gateway_resource" "ping_resource" {
  rest_api_id = aws_api_gateway_rest_api.spring_lambda_api.id
  parent_id   = aws_api_gateway_rest_api.spring_lambda_api.root_resource_id
  path_part   = "ping"
}

resource "aws_api_gateway_method" "ping_method" {
  rest_api_id   = aws_api_gateway_rest_api.spring_lambda_api.id
  resource_id   = aws_api_gateway_resource.ping_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.spring_lambda_api.id
  resource_id             = aws_api_gateway_resource.ping_resource.id
  http_method             = aws_api_gateway_method.ping_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.spring_lambda.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.spring_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.spring_lambda_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.spring_lambda_api.id
  stage_name  = "dev"
}

output "api_gateway_url" {
  value = "http://${aws_api_gateway_rest_api.spring_lambda_api.id}.execute-api.localhost.localstack.cloud:4566/${aws_api_gateway_deployment.api_deployment.stage_name}/ping"
}