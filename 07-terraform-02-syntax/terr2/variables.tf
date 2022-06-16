# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1g9paqpgfec5bnai2m4"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gqao3en7najrn0tpgl"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
# с прошлого ДЗ
#variable "centos-7-base" {
#  default = "fd8a5jqrsmshvrmqmul1"
#}
