
resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      var.local_cidr,
    ]
  }

  ingress {
    from_port = 8200
    to_port   = 8200
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
      var.local_cidr,
      "10.0.0.0/8",
    ]
  }
  tags = {
    owner   = var.prefix
    region  = var.hashi-region
    purpose = var.purpose
    ttl     = var.ttl
  }
}

resource "aws_security_group" "worker_group_mgmt_two" {
  name_prefix = "worker_group_mgmt_two"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
      var.local_cidr,
    ]
  }

    ingress {
    from_port = 8200
    to_port   = 8200
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
      var.local_cidr,
      "10.0.0.0/8",
    ]
  }
  tags = {
    owner   = var.prefix
    region  = var.hashi-region
    purpose = var.purpose
    ttl     = var.ttl
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
      var.local_cidr,
    ]
  }
  ingress {
    from_port = 5557
    to_port   = 5557
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }

  ingress {
    from_port = 8200
    to_port   = 8200
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
      var.local_cidr
    ]
  }
  tags = {
    owner   = var.prefix
    region  = var.hashi-region
    purpose = var.purpose
    ttl     = var.ttl
  }
}
