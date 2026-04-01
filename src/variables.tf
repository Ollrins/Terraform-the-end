###cloud vars

variable "service_account_key_file" {
  type        = string
  description = "Path to service account key file"
}

variable "ssh_public_key" {
  type        = string
  description = "Path to public SSH key file"
  default     = "/home/Ollrins/key.pub"
}


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vm_image_id" {
  description = "Ubuntu 22.04 image ID"
  default     = "fd8ljvsrm3l1q2tgqji9"  # ubuntu-22-04-lts
}

variable "db_password" {
  description = "MySQL database password"
  sensitive   = true
}
variable "db_user" {
  description = "MySQL database user"
  type        = string
  default     = "app"
}

variable "db_name" {
  description = "MySQL database name"
  type        = string
  default     = "devoll"
}

variable "vm_resources" {
  description = "VM resources"
  type = object({
    cores  = number
    memory = number
    disk   = number
  })
  default = {
    cores  = 2
    memory = 4
    disk   = 20
  }
}

variable "db_resources" {
  description = "MySQL cluster resources"
  type = object({
    preset_id = string
    disk_size = number
  })
  default = {
    preset_id = "s2.micro"
    disk_size = 20
  }
}

variable "app_image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "ssh_private_key" {
  description = "Path to private SSH key"
  type        = string
}
