data "http" "local_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "tubesight_db_sg" {
    name = "tubesight-db-sg"
    description = "Allow db access from my IP"
    vpc_id = aws_vpc.default.id
    ingress {
        cidr_blocks = ["${chomp(data.http.local_ip.response_body )}/32"]
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
    }
    tags = {
      "product_name" = var.product
      "resource" = "${var.product}-sg"
    }
}