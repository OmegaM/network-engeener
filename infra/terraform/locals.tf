locals {
  instances_merged_list = flatten([for instance in var.instances :
    [for iterator in range(instance.count) :
      merge(instance, {name = try("${instance.name}-${iterator}", "ne-instance-${iterator}")})
    ]
  ])
}