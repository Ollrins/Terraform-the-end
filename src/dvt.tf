locals {
  ssh_key_content = file(var.ssh_public_key)
  vm_metadata = {
    ssh-keys = "ubuntu:${local.ssh_key_content}"
    user-data = <<-EOT
      #cloud-config
      package_update: true
      package_upgrade: true

      users:
        - name: ubuntu
          groups: sudo
          shell: /bin/bash
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          ssh_authorized_keys:
            - ${local.ssh_key_content}

      runcmd:
        - curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
        - sh /tmp/get-docker.sh
        - systemctl enable docker
        - systemctl start docker
        - usermod -aG docker ubuntu
        - mkdir -p /opt/webapp
    EOT
  }
}

resource "yandex_compute_instance" "webapp" {
  name        = "dev-oll"
  zone        = var.zone
  platform_id = "standard-v2"

  resources {
    cores  = var.vm_resources.cores
    memory = var.vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = var.vm_resources.disk
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.default.id
    security_group_ids = [yandex_vpc_security_group.devoll.id]
    nat                = true
  }

  metadata = local.vm_metadata

  depends_on = [
    yandex_mdb_mysql_cluster.dev_db
  ]
}

# Container Registry
resource "yandex_container_registry" "default" {
  name = "dev-registry"
}

resource "yandex_container_registry_iam_binding" "public_access" {
  registry_id = yandex_container_registry.default.id
  role        = "container-registry.images.puller"
  members     = ["system:allUsers"]
}

output "vm_external_ip" {
  value = yandex_compute_instance.webapp.network_interface[0].nat_ip_address
}

output "registry_id" {
  value = yandex_container_registry.default.id
}

output "db_host" {
  value = yandex_mdb_mysql_cluster.dev_db.host[0].fqdn
}
