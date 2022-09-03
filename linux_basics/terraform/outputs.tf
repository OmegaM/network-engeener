output "instances_ip" {
  value = try(values(yandex_compute_instance.instances).*.network_interface.0.nat_ip_address, values(yandex_compute_instance.instances).*.network_interface.0.ip_address)
}

resource "local_file" "ansible_inventory" {
  content = templatefile("../../../infra/terraform/templates/ansible_inventory.tftpl",
  {
    terraform_instances = try(values(yandex_compute_instance.instances).*.network_interface.0.nat_ip_address, values(yandex_compute_instance.instances).*.network_interface.0.ip_address),
    user = var.ssh_user
  })
  filename = "../../../infra/ansible/inventory/hosts.ini"
}