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
            image_id        = "fd8kdq6d0p8sij7h5qe3" #centos 7 "fd8kdq6d0p8sij7h5qe3" ubuntu 20.04
            count           = 1
            resources       = {
                cpu             = 4
                fraction        = 20
                ram             = 8
    boot_disk_size             = 100
                }
            network_type    = "public"
        }
    ]
}