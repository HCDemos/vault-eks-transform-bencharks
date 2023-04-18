#test2
provider "aws" {
  region = "us-east-2"
}

data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "../terraform.tfstate"
  }
}

# Retrieve EKS cluster configuration
data "aws_subnet" "subnet" {
  id = data.terraform_remote_state.eks.outputs.public_subnet_id
}

data "aws_vpc" "vpc" {
  id = data.terraform_remote_state.eks.outputs.vpc_id
}

resource "aws_security_group" "sg_22_8089" {
  name   = "dpeacock-eks_sg_22_8089"
  vpc_id = data.aws_vpc.vpc.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      var.local_cidr,
      "10.0.0.0/16",]
  }

  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = [var.local_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.local_cidr]
  }

  ingress {
    from_port   = 5557
    to_port     = 5557
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "key-${uuid()}"
  public_key = "${tls_private_key.key.public_key_openssh}"
}

resource "local_file" "pem" {
  filename        = "${aws_key_pair.generated_key.key_name}.pem"
  content         = "${tls_private_key.key.private_key_pem}"
  file_permission = "400"
}

resource "aws_instance" "locust-master" {
  ami            = var.ami_id_value
  instance_type = var.locust_master_instance_type
  associate_public_ip_address = true
  key_name               = aws_key_pair.generated_key.key_name
  subnet_id              = data.aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg_22_8089.id]

  provisioner "file" {
    source      = local_file.pem.filename
    destination = "/home/ubuntu/vault-locust-benchmarks/key-ssh.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 700 /home/ubuntu/vault-locust-benchmarks/key-ssh.pem"
    ]
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    #private_key = local_file.pem.filename
    #private_key = "file(/Users/rajeshkumar/.ssh/id_rsa)"
    private_key = file("./${local_file.pem.filename}")
    host     = aws_instance.locust-master.public_ip
  }

  tags = {
    Name = "${var.prefix}-vpc-${var.region}-locust-master"
    owner = var.prefix
    region = var.hashi-region
    purpose = var.purpose
    ttl = var.ttl
  }
}

resource "aws_instance" "locust-workers" {
  ami            = var.ami_id_value
  instance_type = var.locust_worker_instance_type
  count         = 2
  associate_public_ip_address = true
  key_name               = aws_key_pair.generated_key.key_name
  subnet_id                   = data.aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.sg_22_8089.id]

  tags = {
    Name = "${var.prefix}-vpc-${var.region}-${count.index}"
    owner = var.prefix
    region = var.hashi-region
    purpose = var.purpose
    ttl = var.ttl
  }
}

