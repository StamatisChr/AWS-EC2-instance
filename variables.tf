variable "aws_region" {
  description = "The AWS region in use to spawn the resources"
  type        = string
  default     = "eu-west-1"
}

variable "use_user_data" {
  description = "Choose to provide or not the user_data for the EC2 instance. The user_data template file can be found in the templates folder"
  type        = bool
  default     = true
}

variable "tfe_instance_type" {
  description = "The ec2 instance type"
  type        = string
  default     = "t3.small"
}

variable "root_block_device_disk_size" {
  description = "The size of the root block device (disk) of the ec2 instance in GB"
  type        = number
  default     = 30
}

variable "ingress_ports" {
  description = "The list of ingress ports to allow in the security group"
  type        = list(number)
  default     = []
}