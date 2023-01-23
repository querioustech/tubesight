data "aws_secretsmanager_secret" "statistics_db_meta" {
    name = "${var.secret_prefix}/${var.environment}/statistics-db"
}

data "aws_secretsmanager_secret_version" "statistics_db" {
    secret_id = data.aws_secretsmanager_secret.statistics_db_meta.id
}