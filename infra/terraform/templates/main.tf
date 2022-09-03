terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  experiments      =  [module_variable_optional_attrs]
}

module "${lesson_name}" {
    source = "../../../infra/terraform"
    instances = var.instances
}

output "instance_ip" {
  value = module.${lesson_name}.instances_ip
}