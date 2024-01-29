# variable "folder_id" {
#   type = string
# }

variable "vpc_name" {
  type = string
  description = "VPC name"
  default = "VPC"
}

variable "zone" {
  type = string
  default = "ru-central1-a"
  description = "zone"
}

variable "subnet_name" {
  type = string
  description = "subnet name"
  default = "internal-lan"
}

variable "subnet_cidrs" {
  type = list(string)
  description = "CIDRs"
  default = ["10.0.10.0/24"]
}

## ## ##    Параметры VM    ## ## ##
variable "cpu" {
  description = "Количество процессоров виртуальной машины"
  default     = 2
  type        = number
}

variable "memory" {
  description = "Размер оперативной памяти виртуальной машины (ГБ)"
  default     = 2
  type        = number
}

variable "core_fraction" {
  description = "Доля ядра, по умолчанию 100%"
  default     = 100
  type        = number
}

variable "disk_for_proxy" {
  description = "Размер диска виртуальной машины"
  default     = 5
  type        = number
}

variable "disk_for_other" {
  description = "Размер диска виртуальной машины"
  default     = 10
  type        = number
}

variable "image_id_for_proxy" {
  description = "Default image ID Ubuntu 20.04"
  default     = "fd879gb88170to70d38a" # ubuntu-22-04-lts
  type        = string
}

variable "image_id_for_other" {
  description = "Default image ID Ubuntu 22.04"
  default     = "fd8vljd295nqdaoogf3g" # ubuntu-22-04-lts
  type        = string
}

variable "nat" {
  type    = bool
  default = true
}

variable "platform_id" {
  type    = string
  default = "standard-v3"
}

variable "internal_ip_address_webproxy" {
  type    = string
  default = "10.0.10.3"
}

variable "internal_ip_address_sql" {
  type    = string
  default = "10.0.10.6"
}

variable "nat_ip_address" {
  type    = string
  default = null
}

variable "disk_type" {
  description = "Тип Диска"
  type        = string
  default     = "network-ssd"
}

variable "type_remote_exec" {
  description = "Тип подключения для remote-exec"
  type        = string
  default     = "ssh"
}

variable "user" {
  description = "Создаёт пользователя на удаленной машине"
  type        = string
  default     = "ubuntu"
}

variable "private_key" {
  description = "Закрытый ключ SSH для доступа к VM (remote-exec)"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "timeout" {
  description = "Параметр таймаута для remote-exec"
  type        = string
  default     = "10"
}

variable "playbook" {
  description = "Путь к ansible playbook, который будет выполняться с созданным хостом в качестве инвентаря."
  type        = string
  default     = "~/homework/lession3/ansible/provision.yml"
}

variable "shard_count" {
  default = "1"
  description = "Number of shards"
  }

variable "shardsvr_replicas" {
  default = "2"
 description = "How many replicas per shard"
  }