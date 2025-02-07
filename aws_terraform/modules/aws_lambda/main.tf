# Creates a zip file to store the lambda function in so that it can be uploaded
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/${var.source_file_name}"
  output_path = "${path.module}/${var.function_name}.zip"
}

# Creates the lambda function based off the variables provided
resource "aws_lambda_function" "lambda_function" {
  function_name    = var.function_name
  role             = lookup(var.role_arn, "lambda_execution_role", "")
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  environment {
    variables = {
      GITHUB_WEBHOOK_URL = var.github_webhook_url
      GITHUB_TOKEN       = var.github_pa_token
    }
  }

  tags = merge(
    var.tags, {
      Name   = var.function_name
      Module = "aws_lambda"
    }
  )
}

# Creates an EventBridge Rule to trigger the Lambda function on EC2 startup
resource "aws_cloudwatch_event_rule" "ec2_state_change" {
  name          = var.event_rule_name
  description   = var.event_rule_description
  event_pattern = var.event_pattern
  tags = merge(
    var.tags, {
      Name   = var.function_name
      Module = "aws_lambda"
    }
  )
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.ec2_state_change.name
  target_id = var.event_target_id
  arn       = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = var.statement_id
  action        = var.lambda_permission_action
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = var.principal
  source_arn    = aws_cloudwatch_event_rule.ec2_state_change.arn
}


