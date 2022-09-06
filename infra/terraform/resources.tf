resource "yandex_compute_instance" "instances" {
    for_each = { for instance in local.instances_merged_list : instance.name => instance }

    name                        = each.value.name
    allow_stopping_for_update   = true
    
    resources {
      cores         = each.value.resources.cpu
      core_fraction = each.value.resources.fraction
      memory        = each.value.resources.ram
    }

    boot_disk {
        initialize_params {
            image_id    = each.value.image_id
            size        = try(each.value.resources.boot_disk_size, 10)
        } 
    }
    dynamic "secondary_disk"{
        for_each    = var.custom_disk == null ? [] : ["One instance - one disk"]
        content {
            disk_id     = yandex_compute_disk.custom_disk[0].id
            auto_delete = var.custom_disk.autoDelete
        } 
    }
    
    network_interface { 
        subnet_id   = data.yandex_vpc_subnet.subnets[each.value.network_type].id
        nat         = each.value.network_type == "public" ? true : false
    }

    metadata = {
        ssh-keys = "${var.ssh_user}:${file("~/.ssh/id_rsa.pub")}"
    }
}

resource "yandex_compute_disk" "custom_disk" {
    count = var.custom_disk == null ? 0 : 1

    type    = var.custom_disk.isReplicated ? var.custom_disk.type : var.custom_disk.type == "network-ssd" ? "${var.custom_disk.type}-nonreplicated" : var.custom_disk.type
    size    = var.custom_disk.size
}