# create ec2 instance
resource "aws_instance" "tf_aws_ec2_instance" {
  ami           = data.aws_ami.ubuntu_2404.id
  instance_type = var.tfe_instance_type
  vpc_security_group_ids = [aws_security_group.tf_security_group.id]

  user_data = var.use_user_data ? templatefile("./templates/user_data_cloud_init.tftpl", {}): null

  ebs_optimized = true
  root_block_device {
    volume_size = var.root_block_device_disk_size
    volume_type = "gp3"

  }

  tags = {
    Name = "managed by Terraform"
  }
}

resource "aws_security_group" "tf_security_group" {
  name        = "tf_aws_ec2_instance_sg"
  description = "Allow inbound traffic and outbound"

  tags = {
    Name = "managed by Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ports" {
  for_each = { for port in var.ingress_ports : port => port }

  security_group_id = aws_security_group.tf_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = each.value
  to_port           = each.value
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic_ipv4" {
  security_group_id = aws_security_group.tf_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}