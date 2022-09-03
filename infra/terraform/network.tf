resource "yandex_vpc_network" "vpc" {
    name    = "network-engeneer-vpc"
}

resource "yandex_vpc_subnet" "subnets" {
    for_each    = { for sn in var.subnets : sn.type => sn }

    name            = "${each.value.type}-network"
    zone            = each.value.zone
    network_id      = yandex_vpc_network.vpc.id
    v4_cidr_blocks  = each.value.cidr
    description     = each.value.type
}