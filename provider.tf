locals {
  cloud_id           = ""
  folder_id          = ""
  zone               = "ru-central1-a"
}

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}


provider "yandex" {
  cloud_id  = local.cloud_id
  folder_id = local.folder_id
}
