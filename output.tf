output "Proxy" {
  value = "${yandex_compute_instance.proxy.network_interface.0.nat_ip_address}"
}
output "Web-MAIN" {
  value = "${yandex_compute_instance.website.0.network_interface.0.nat_ip_address}"
}
output "Web-Mirror" {
  value = "${yandex_compute_instance.website.1.network_interface.0.nat_ip_address}"
}
output "Mysql" {
  value = "${yandex_compute_instance.database.network_interface.0.nat_ip_address}"
}