# Provider

provider "yandex" {
#  service_account_key_file = "key.json"
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
  zone      = "ru-central1-a"
}

data "yandex_iam_user" "korsh" {
  login = "andrey.korsh"
}

data "yandex_iam_service_account" "korsh" {
  service_account_id = "aje6rc0m603ndukqk85b"
}


resource "yandex_compute_image" "korsh-node-img" {
  name         = "korsh-node-img"
# стандартный образ | fd80rnhvc47031anomed | centos-7-v20220613 
  source_image = "fd80rnhvc47031anomed"	
  }

resource "yandex_compute_instance" "korsh-node01" {
  name                      = "korsh-node01"
  zone                      = "ru-central1-a"
  hostname                  = "korsh_node01.netology.cloud"
  allow_stopping_for_update = true

  network_interface {
    subnet_id = "e9b6hja9f62sr65uhgqp"
    nat       = true
  }


  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
# стандартный образ | fd80rnhvc47031anomed | centos-7-v20220613
# если нужен именно созданный образ, то нужно подставить его id
      image_id = "fd80rnhvc47031anomed"      
      name        = "root-korsh-node01"
      type        = "network-nvme"
      size        = "30"
    }

  }
}
