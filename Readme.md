# Create an AWS EC2 instance with terraform

## What is this repository about?
Use this repository to create an AWS EC2 instance with Ubuntu 24.04 operating system and have docker installed.
The main goal is to easily spawn an EC2 instance for simple tests.

## Prerequisites
- An AWS account with access to EC2 resources
- Git installed on your PC/laptop
  - See [How to install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- Terraform installed on your PC/laptop
  - See  [How to install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- AWS cli installed on your PC/laptop (optional)
  - See [How to install AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

# How to use this terraform code?

## Set AWS credentials for terraform
Export your AWS access key and secret access key as environment variables, terraform will use them to connect to your AWS account.

If you have AWS cli configured on your PC/laptop you can skip this step. 
More details [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration).

```bash
export AWS_ACCESS_KEY_ID=<your_access_key_id>
```

```bash
export AWS_SECRET_ACCESS_KEY=<your_secret_key>
```

## Clone the git repository

Open your terminal and run:
```bash
git clone git@github.com:StamatisChr/TF-AWS-EC2-instance.git
```

When the repository cloning is finished, change directory to the repo’s terraform directory:

```bash
cd TF-AWS-EC2-instance
```

## Edit EC2 instance properties

Edit the `variables.tf` with the text editor of your choice. 
There are 4 properties that you can change here, AWS region, EC2 instance disk size, EC2 instance type and also set on which ports the incoming traffic is allowed. Also you can choose if you want to pass the user_data script to the EC2 instance. 

The variables have default values, you do not have to change them if you don't need to.By default user_data will pass to the EC2 instance and docker will be installed.

- variable `"aws_region"` the default value is `"eu-west-1"`, change it to the region of your preference
- variable `"use_user_data"` the default value is `true` and docker will be installed, set it to `false` if you don't need docker
- variable `"tfe_instance_type"` the default value is `"t3.small"`
- variable `"root_block_device_disk_size"`, the disk size of the EC2 instance in GB, the default value is 30.
- variable `"ingress_ports"` a list of allowed incoming traffic ports. By default port 22 is allowed, if you remove it you will not be able to connect to the EC2 instance. You can add more ports seperating them with a comma, for example, if you want to add port 80 and 443, the value should look like this: `[22, 80, 443]`  

Save your changes.

## Create the resources with terraform 

To initialize terraform, run:
```bash
terraform init
```

To create the resources with terraform, run:
```bash
terraform apply
```

Review the terraform plan, it shows the resources that terraform will create.

Type `yes` when prompted with:
```bash
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```  

When apply is finished, you will have an output like this:
```bash
...
...
...
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

connect_with_ec2_instance_connect = "https://eu-west-1.console.aws.amazon.com/ec2-instance-connect/ssh/home?addressFamily=ipv4&connType=standard&instanceId=i-0952cdd305c45cd83&osUser=ubuntu&region=eu-west-1&sshPort=22"

```

If you open the `connect_with_ec2_instance_connect` URL you will be redirected on the AWS EC2 console with an ssh session open to the EC2 instance via the EC2 Instance Connect (requires ssh port 22 to be allowed)

You are now connected to the EC2 instance.

## Clean up
To delete all the resources created by terraform, go back to your terminal, in the directory you copied the git repository and run:
```bash
terraform destroy
```

Type `yes` when prompted.

Wait for the resource deletion.

```bash
Destroy complete! Resources: 5 destroyed.
```

Done.