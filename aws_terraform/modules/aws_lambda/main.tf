# Creates the zip files for the 2 python scripts so that they can be uploaded
data "archive_file" "enrich_ec2_tags_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_functions/enrich_ec2_tags.py"
  output_path = "${path.module}/lambda_functions/enrich_ec2_tags.zip"
}

data "archive_file" "github_webhook_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_functions/${var.source_file_name}"
  output_path = "${path.module}/lambda_functions/${var.function_name}.zip"
}

# Creates the lambda function to add the EC2 instance tags to the event
resource "aws_lambda_function" "enrich_ec2_tags" {
  function_name    = "${var.function_name}-enrich-tags"
  role             = lookup(var.role_arn, "lambda_execution_role", "")
  handler          = "enrich_ec2_tags.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.enrich_ec2_tags_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.enrich_ec2_tags_zip.output_path)
  timeout          = 900
  lifecycle {
    replace_triggered_by = [ terraform_data.replacement ]
  }
  tags = merge(
    var.tags, {
      Name   = "${var.function_name}-enrich-tags"
      Module = "aws_lambda"
    }
  )
}

# Creates the lambda function for the github webhook to be triggered
resource "aws_lambda_function" "trigger_github_webhook" {
  function_name    = var.function_name
  role             = lookup(var.role_arn, "lambda_execution_role", "")
  handler          = "trigger_github_webhook.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.github_webhook_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.github_webhook_zip.output_path)
  timeout          = 900
  environment {
    variables = {
      GITHUB_WEBHOOK_URL    = var.github_webhook_url
      GITHUB_PA_TOKEN       = var.github_pa_token
    }
  }
  lifecycle {
    replace_triggered_by = [ terraform_data.replacement ]
  }
  tags = merge(
    var.tags, {
      Name   = var.function_name
      Module = "aws_lambda"
    }
  )
}

# Creates an EventBridge Rule to trigger the Lambda function when the EC2 state reaches "running"
resource "aws_cloudwatch_event_rule" "ec2_state_change" {
  name          = var.event_rule_name
  description   = var.event_rule_description
  event_pattern = var.event_pattern
  
  tags = merge(
    var.tags, {
      Name   = var.event_rule_name
      Module = "aws_lambda"
    }
  )
}

# Creates a second EventBridge rule to filter the enriched events based on the tags of the instance
resource "aws_cloudwatch_event_rule" "filter_enriched_ec2_events" {
  name          = "${var.event_rule_name}-filter-tags"
  description   = "Filter enriched EC2 state-change events based on the Name tag"
  event_pattern = <<PATTERN
{
  "detail": {
    "tags": {
      "Name": ["${var.server_name}"]
    }
  }
}
PATTERN

  tags = merge(
    var.tags, {
      Name   = "${var.event_rule_name}-filter-tags"
      Module = "aws_lambda"
    }
  )
}

# Points the CloudWatch event to target the enrich_ec2_tags Lambda function
resource "aws_cloudwatch_event_target" "enrich_ec2_tags_target" {
  rule      = aws_cloudwatch_event_rule.ec2_state_change.name
  target_id = "${var.event_target_id}-enrich-tags"
  arn       = aws_lambda_function.enrich_ec2_tags.arn
}

# Points the CloudWatch event to target the GitHub webhook Lambda function when it matches the filtered event
resource "aws_cloudwatch_event_target" "github_webhook_lambda_target" {
  rule      = aws_cloudwatch_event_rule.filter_enriched_ec2_events.name
  target_id = var.event_target_id
  arn       = aws_lambda_function.trigger_github_webhook.arn
}

# Grants EventBridge permission to invoke the enrich_ec2_tags Lambda function
resource "aws_lambda_permission" "allow_cloudwatch_enrich" {
  statement_id  = "${var.statement_id}-enrich"
  action        = var.lambda_permission_action
  function_name = aws_lambda_function.enrich_ec2_tags.function_name
  principal     = var.principal
  source_arn    = aws_cloudwatch_event_rule.ec2_state_change.arn
  lifecycle {
    replace_triggered_by = [ terraform_data.replacement ]
  }
}

# Grants EventBridge permission to invoke the trigger_github_webhook Lambda function
resource "aws_lambda_permission" "allow_cloudwatch_github" {
  statement_id  = var.statement_id
  action        = var.lambda_permission_action
  function_name = aws_lambda_function.trigger_github_webhook.function_name
  principal     = var.principal
  source_arn    = aws_cloudwatch_event_rule.filter_enriched_ec2_events.arn
  lifecycle {
    replace_triggered_by = [ terraform_data.replacement ]
  }
}

# Just to trigger a recreation of the Lambda functions when the python files change
resource "terraform_data" "replacement" {
  input = [
    filebase64sha256("${path.module}/lambda_functions/enrich_ec2_tags.py"),
    filebase64sha256("${path.module}/lambda_functions/${var.source_file_name}"),
  ]
}
