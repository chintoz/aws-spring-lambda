resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "SpringLambdaErrors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm if SpringLambda function has errors"
  dimensions = {
    FunctionName = aws_lambda_function.spring_lambda.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  alarm_name          = "SpringLambdaDuration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Average"
  threshold           = 5000  # Duration in milliseconds
  alarm_description   = "Alarm if SpringLambda function duration exceeds 5 seconds"
  dimensions = {
    FunctionName = aws_lambda_function.spring_lambda.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_invocations" {
  alarm_name          = "SpringLambdaInvocations"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Invocations"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 100  # Number of invocations
  alarm_description   = "Alarm if SpringLambda function is invoked more than 100 times in a minute"
  dimensions = {
    FunctionName = aws_lambda_function.spring_lambda.function_name
  }
}

