output "connect_with_ec2_instance_connect" {
  description = "use the following URL to connect to your ec2 instance with AWS EC2 Instance Connect"
  value       = "https://eu-west-1.console.aws.amazon.com/ec2-instance-connect/ssh/home?addressFamily=ipv4&connType=standard&instanceId=${aws_instance.tf_aws_ec2_instance.id}&osUser=ubuntu&region=${var.aws_region}&sshPort=22"
}