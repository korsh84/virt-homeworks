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


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = local.web_instance_count_map

  name = "instance-${each.key}"

  ami                    = "ami-ebd02392"
  instance_type          = local.web_instance_type_map[terraform.workspace]
  #key_name               = "user1"
  #monitoring             = true
  #vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  
}



# без ключей доступа не дает запросит данные
#data "aws_caller_identity" "korsh-aws-caller" {}
data "aws_region" "korsh-aws-region" {}
 
