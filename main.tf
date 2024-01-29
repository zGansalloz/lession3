resource "yandex_vpc_network" "vpc" {
  # folder_id = var.folder_id
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
  # folder_id = var.folder_id
  v4_cidr_blocks = var.subnet_cidrs
  zone           = var.zone
  name           = var.subnet_name
  network_id = yandex_vpc_network.vpc.id
}

resource "yandex_compute_instance" "proxy" {
  name = "webproxy"
  platform_id = var.platform_id
  zone        = var.zone
  labels = {
    ansible-group = "proxy"
  }

  resources {
    cores         = var.cpu
    memory        = var.memory
    core_fraction = var.core_fraction
  }


  boot_disk {
    initialize_params {
      image_id = var.image_id_for_proxy
      size     = var.disk_for_proxy
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = var.nat
    ip_address         = var.internal_ip_address_webproxy
    nat_ip_address     = var.nat_ip_address
  }

  metadata = {
    ssh-keys           = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
  }


 provisioner "remote-exec" {
    connection {
      type        = var.type_remote_exec
      user        = var.user
      host        = self.network_interface.0.nat_ip_address
      private_key = file("${var.private_key}")
    }

    inline = [
       "uptime"
    ]
 }

#provisioner "local-exec" {
#        command = "ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -u ${var.user} -i '${yandex_compute_instance.wordpress.network_interface.0.nat_ip_address},' --private-key '${var.private_key}' ${var.playbook_wordpress}"
#    }
}

resource "yandex_compute_instance" "website" {
  count = var.shard_count * var.shardsvr_replicas
  name = "website${floor(count.index / var.shardsvr_replicas )}svr${count.index % var.shardsvr_replicas}"
  platform_id = var.platform_id
  zone        = var.zone
  labels = {
    ansible-group = floor(count.index / var.shardsvr_replicas ),
    ansible-index = count.index % var.shardsvr_replicas,
  }
  # folder_id   = var.folder_id

  resources {
    cores         = var.cpu
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id_for_other
      size     = var.disk_for_other
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = var.nat
    ip_address         = "10.0.10.1${floor(count.index)}"
    nat_ip_address     = var.nat_ip_address
  }

  metadata = {
    ssh-keys           = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
  }


 provisioner "remote-exec" {
    connection {
      type        = var.type_remote_exec
      user        = var.user
      host        = self.network_interface.0.nat_ip_address
      private_key = file("${var.private_key}")
    }

    inline = [
      "uptime"
    ]
 }
}

resource "yandex_compute_instance" "database" {
  name = "dbserver"
  platform_id = var.platform_id
  zone        = var.zone
  labels = {
    ansible-group = "database"
  }
  # folder_id   = var.folder_id

  resources {
    cores         = var.cpu
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id_for_other
      size     = var.disk_for_other
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = var.nat
    ip_address         = var.internal_ip_address_sql
    nat_ip_address     = var.nat_ip_address
  }

  metadata = {
    ssh-keys           = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
  }


 provisioner "remote-exec" {
    connection {
      type        = var.type_remote_exec
      user        = var.user
      host        = self.network_interface.0.nat_ip_address
      private_key = file("${var.private_key}")
    }

    inline = [
      "uptime",
    ]
 }
}

resource "local_file" "ansible_inventory" {
 content = templatefile("inventory.tmpl",
   {
    ansible_group_website = yandex_compute_instance.website.*.labels.ansible-group,
    ansible_group_index = yandex_compute_instance.website.*.labels.ansible-index,
    ansible_group_proxy = yandex_compute_instance.proxy.*.labels.ansible-group,
    ansible_group_database = yandex_compute_instance.database.*.labels.ansible-group,

    hostname_proxy = yandex_compute_instance.proxy.*.name,
    hostname_website = yandex_compute_instance.website.*.name,
    hostname_database = yandex_compute_instance.database.*.name,

    ip_address_proxy=yandex_compute_instance.proxy.network_interface.0.nat_ip_address,
    ip_address_website=yandex_compute_instance.website.*.network_interface.0.nat_ip_address,
    ip_address_database=yandex_compute_instance.database.network_interface.0.nat_ip_address,

    user_proxy = "${var.user}",
    user_database = "${var.user}",
    user_website = "${var.user}",

    private_key_proxy = "${var.private_key}",
    private_key_website = "${var.private_key}",
    private_key_database = "${var.private_key}",

    number_of_shards = range(var.shard_count)
   }
 )
  filename = "./ansible/inventory"
  provisioner "local-exec" {
        command = "ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -u ${var.user} -i './ansible/inventory' ${var.playbook}"
    }
}