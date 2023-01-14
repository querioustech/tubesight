# Cloudwatch Event to trigger get_youtube_data lambda periodically

resource "aws_cloudwatch_event_rule" "every_thirty_minutes" {
    name = "${var.product}-every-thirty-minutes"
    description = "Fires every thirty minutes"
    schedule_expression = "rate(30 minutes)"
    tags = {
        "product_name" = var.product
        "resource" = "${var.product}-every-thirty-minutes-cw-rule"
    }
}

resource "aws_cloudwatch_event_target" "get_youtube_data_every_thirty_minutes" {
    rule = aws_cloudwatch_event_rule.every_thirty_minutes.name
    target_id = "${var.product}-${var.environment}-get-youtube-data-trigger"
    arn = aws_lambda_function.get_youtube_data.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_on_get_youtube_data" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.get_youtube_data.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.every_thirty_minutes.arn
}

# S3 Notification to trigger store_stats lambda

resource "aws_s3_bucket_notification" "bucket_notification" {
    bucket = aws_s3_bucket.api_responses_bucket.id
    lambda_function {
        lambda_function_arn = aws_lambda_function.store_stats.arn
        events              = ["s3:ObjectCreated:*"]
    }

    depends_on = [aws_lambda_permission.allow_api_responses_bucket]
}

resource "aws_lambda_permission" "allow_api_responses_bucket" {
    statement_id  = "AllowExecutionFromS3Bucket"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.store_stats.arn
    principal     = "s3.amazonaws.com"
    source_arn    = aws_s3_bucket.api_responses_bucket.arn
}