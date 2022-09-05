data "yandex_vpc_subnet" "subnets" {
    for_each    = { for sn in var.subnets : sn.type => sn }
    subnet_id   = yandex_vpc_subnet.subnets[each.value.type].id
}