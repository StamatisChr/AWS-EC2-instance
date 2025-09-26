# create ec2 instance
resource "aws_instance" "tf_aws_ec2_instance" {
  ami           = data.aws_ami.ubuntu_2404.id
  instance_type = var.tfe_instance_type
  vpc_security_group_ids = [aws_security_group.tf_security_group.id]
  iam_instance_profile = aws_iam_instance_profile.tfe_ssm_access.name

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


resource "aws_iam_role" "tfe_ssm_access" {
  name = "tfe_ssm_access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Name = "managed by Terraform"
  }
}

resource "aws_iam_instance_profile" "tfe_ssm_access" {
  name = "tfe_ssm_access_profile"
  role = aws_iam_role.tfe_ssm_access.name
}

resource "aws_iam_role_policy_attachment" "SSM" {
  role       = aws_iam_role.tfe_ssm_access.name
  policy_arn = data.aws_iam_policy.SecurityComputeAccess.arn
}