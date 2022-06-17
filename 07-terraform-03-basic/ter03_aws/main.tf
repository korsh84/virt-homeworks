# Provider

provider "aws" {
  region = "us-west-2"
  # настройки для пропуска проверки ключей
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"

  endpoints {
    dynamodb = "http://localhost:4569"
    s3       = "http://localhost:4572"
######
  }
}

#$ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
#$ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

/*data "aws_ami" "ubuntu" {
# без access key не дает фильтровать 
    most_recent = true
    # default id https://ubuntu.com/server/docs/cloud-images/amazon-ec2
	owners = ["099720109477"]
    filter {
       name   = "name"
       values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
    }

}

# для проверки
output "test" {
  value = data.aws_ami.ubuntu
}*/



## сети 
resource "aws_vpc" "korsh_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "korsh-aws-tf-example"
  }
}

resource "aws_subnet" "korsh_subnet" {
  vpc_id            = aws_vpc.korsh_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2"

  tags = {
    Name = "korsh-aws-tf-example"
  }
}

resource "aws_network_interface" "korsh-aws-iface" {
  subnet_id   = aws_subnet.korsh_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}


locals {
   web_instance_type_map = {
      stage = "t3.micro"
      prod = "t3.large"
   }
}

locals {
   web_instance_count_map = {
       stage = 1
       prod = 2
   }
}


resource "aws_instance" "web" {
   #ami = data.aws_ami.ubuntu.id
   # пришлось использовать гоовое имя образа
   ami = "ami-22b9a343"
   instance_type = local.web_instance_type_map[terraform.workspace]
   count = local.web_instance_count_map[terraform.workspace]
   #instance_type = "t3.micro"
   host_id = "korsh-aws-test"
   credit_specification {
      cpu_credits = "unlimited"
   }
   
   lifecycle {
      create_before_destroy = true
      #prevent_destroy = true
      #ignore_changes = ["tags"]
   }
   
   network_interface {
    network_interface_id = aws_network_interface.korsh-aws-iface.id
    device_index         = 0
  }
   tags = {
    Name = "Korsh_aws"
  }
}


resource "aws_instance" "web_each" {
   for_each = local.web_instance_count_map
   ami = "ami-22b9a343"
   instance_type = local.web_instance_type_map[terraform.workspace]
   #count = each.value
   #instance_type = "t3.micro"
   host_id = "korsh-aws-test"
   credit_specification {
      cpu_credits = "unlimited"
   }
   
   network_interface {
    network_interface_id = aws_network_interface.korsh-aws-iface.id
    device_index         = 0
  }
   tags = {
    Name = "Korsh_aws"
  }
}

# без ключей доступа не дает запросит данные
#data "aws_caller_identity" "korsh-aws-caller" {}
data "aws_region" "korsh-aws-region" {}
 
