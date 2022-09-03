output "instances_ip" {
  value = try(values(yandex_compute_instance.instances).*.network_interface.0.nat_ip_address, values(yandex_compute_instance.instances).*.network_interface.0.ip_address)
}
