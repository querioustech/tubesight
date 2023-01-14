resource "aws_iam_role" "get_youtube_data_lambda_exec_role" {
  name = "get_youtube_data_lambda_exec_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
  tags = {
    "product_name" = "tubesight"
    "resource" = "tubesight-get_youtube_data_lambda_exec_role"
  }
}

data "aws_iam_policy_document" "get_youtube_data_lambda_policy_doc" {
  statement {
    sid = "AllowInvokingLambdas"
    effect = "Allow"

    resources = [
      "arn:aws:lambda:*:*:function:*"
    ]

    actions = [
      "lambda:InvokeFunction"
    ]
  }

  statement {
    sid = "AllowCreatingLogGroups"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:*"
    ]

    actions = [
      "logs:CreateLogGroup"
    ]
  }

  statement {
    sid = "AllowWritingLogs"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*"
    ]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    sid = "AllowReadingSecrets"
    effect = "Allow"

    resources = [
      "arn:aws:secretsmanager:*:*:secret:*"
    ]

    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
  }

  statement {
    sid = "PutObjects"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::${var.product}-${var.environment}-responses-raw/*"
    ]

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
  }
}

resource "aws_iam_policy" "get_youtube_data_lambda_iam_policy" {
  name = "get_youtube_data_lambda_iam_policy"
  policy = data.aws_iam_policy_document.get_youtube_data_lambda_policy_doc.json
  tags = {
    "product_name" = "tubesight"
    "resource" = "tubesight-get_youtube_data_lambda_iam_policy"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.get_youtube_data_lambda_iam_policy.arn
  role = aws_iam_role.get_youtube_data_lambda_exec_role.name
}