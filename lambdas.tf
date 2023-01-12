resource "null_resource" "install_function_dependencies" {
    provisioner "local-exec" {
      command = "bash ${path.module}/backend/scripts/build.sh"
      
      environment = {
        path_cwd = path.cwd
        output_dir = var.output_dir
        functions_dir = var.functions_dir
        runtime = var.runtime
       }
    }
}

data "archive_file" "get_youtube_data_func_build_pkg" {
  depends_on = [null_resource.install_function_dependencies]
  source_dir = "${path.cwd}/${var.output_dir}/get_youtube_data"
  output_path = "${path.cwd}/${var.output_dir}/get_youtube_data.zip"
  type = "zip"
}

resource "aws_lambda_function" "get_youtube_data" {
  function_name = "${var.product}-${var.environment}-get-youtube-data"
  handler = "handler.handler"
  runtime = var.runtime

  role = aws_iam_role.lambda_exec_role.arn
  memory_size = 128
  timeout = 1000

  depends_on = [null_resource.install_function_dependencies]
  source_code_hash = data.archive_file.get_youtube_data_func_build_pkg.output_base64sha256
  filename = data.archive_file.get_youtube_data_func_build_pkg.output_path

  environment {
    variables =  {
      YOUTUBE_API_KEY = "${var.secret_prefix}/${var.environment}/ytdata-apikey"
      REGION = var.region
    }
  }

  tags = {
    "product_name" = var.product
    "resource" = "${var.product}-get-youtube-data"
  }
}