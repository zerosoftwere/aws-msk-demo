data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_security_group" "vpc_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "vpn-sg"

  tags = {
    Name = "VPN sg"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_instance" "vpn" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.nano"
  subnet_id         = aws_subnet.main_subnet.id
  key_name          = aws_key_pair.ssh_key.key_name
  source_dest_check = false

  security_groups = [
    aws_security_group.vpc_sg.id
  ]

  tags = {
    Name = "VPN"
  }
}

output "vpn_ip" {
  value = aws_instance.vpn.public_ip
}

output "vpn_private_ip" {
  value = aws_instance.vpn.private_ip
}