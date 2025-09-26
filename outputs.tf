output "start_aws_ssm_session" {
  value = "aws ssm start-session --target ${aws_instance.tf_aws_ec2_instance.id} --region ${var.aws_region}"
}

output "ec2_instance_details" {
  description = "The details of the EC2 instance"
  value = ({ "public_ip" = aws_instance.tf_aws_ec2_instance.public_ip,
              "public_dns"    = aws_instance.tf_aws_ec2_instance.public_dns,
              "instance_id"   = aws_instance.tf_aws_ec2_instance.id,
              "instance_type" = aws_instance.tf_aws_ec2_instance.instance_type,
              "private_ip"    = aws_instance.tf_aws_ec2_instance.private_ip,
              "private_dns"   = aws_instance.tf_aws_ec2_instance.private_dns })
}