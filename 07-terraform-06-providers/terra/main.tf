terraform {
  required_providers {
    hashicups = {
      version = "0.2"
	source = "hashicups"
//      source  = "hashicorp.com/edu/hashicups"
//	source = "/home/vagrant/.terraform.d/plugins/hashicorp.com/edu/hashicups/0.2/linux_amd64/terraform-provider-hashicups"
    }
  }
}

provider "hashicups" {}

module "psl" {
  source = "./coffee"

  coffee_name = "Packer Spiced Latte"
}

output "psl" {
  value = module.psl.coffee
}
