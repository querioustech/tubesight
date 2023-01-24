resource "aws_db_instance" "statistics_db" {
    identifier = "${var.product}-statistics"
    allocated_storage = 20
    storage_type  = "gp2"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t3.micro"
    db_name = "${var.product}_statistics"
    username = jsondecode(data.aws_secretsmanager_secret_version.statistics_db.secret_string)["username"]
    password = jsondecode(data.aws_secretsmanager_secret_version.statistics_db.secret_string)["password"]
    skip_final_snapshot  = true
    publicly_accessible = true
    vpc_security_group_ids = [aws_security_group.tubesight_db_sg.id]
    tags = {
        "product_name" = var.product
        "resource" = "${var.product}-statistics-db"
    }
}