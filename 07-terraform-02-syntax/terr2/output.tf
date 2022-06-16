
output "YC_account_ID" {
  value = "${data.yandex_iam_service_account.korsh.service_account_id}"
}

output "YC_user_ID" {
  value = "${data.yandex_iam_user.korsh.user_id}"
}


output "korsh-node01_zone" {
  value = "${yandex_compute_instance.korsh-node01.zone}"
}
output "internal_ip_address_korsh-node01_yandex_cloud" {
  value = "${yandex_compute_instance.korsh-node01.network_interface.0.ip_address}"
}

output "internal_subnet_id_korsh-node01_yandex_cloud" {
  value = "${yandex_compute_instance.korsh-node01.network_interface.0.subnet_id}"
}

