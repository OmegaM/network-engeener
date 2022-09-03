variable "subnets" {
    type = list(object({
        type    = string
        zone    = string
        cidr    = list(string)
    }))
    default = [
        {
            type = "public"
            zone = "ru-central1-a"
            cidr = ["192.168.10.0/24"]
        }
    ]
}

variable "instances" {
    type    = list(object({
        name            = optional(string)
        image_id        = string
        count           = number
        resources       = object({
            cpu             = number
            fraction        = number
            ram             = number
            boot_disk_size  = optional(number)
        })
        network_type    = string
    }))
    default = [
        {
            image_id        = "fd8ad4ie6nhfeln6bsof" #centos 7
            count           = 1
            resources       = {
                cpu             = 2
                fraction        = 20
                ram             = 1
            }
            network_type    = "public"
        }
    ]
}

variable "ssh_user" {
  type  = string
  default = "centos"
}