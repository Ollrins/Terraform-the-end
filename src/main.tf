# Network
resource "yandex_vpc_network" "default" {
  name = "dev-network"
}

resource "yandex_vpc_subnet" "default" {
  name           = "dev-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Security Group
resource "yandex_vpc_security_group" "devoll" {
  name        = "dev-oll"
  description = "Security group for web application"
  network_id  = yandex_vpc_network.default.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "TCP"
    description    = "WebApp 8090"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8090
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Managed MySQL Cluster
resource "yandex_mdb_mysql_cluster" "dev_db" {
  name        = "dev-db"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.default.id
  version     = "8.0"

  resources {
    resource_preset_id = var.db_resources.preset_id
    disk_type_id       = "network-hdd"
    disk_size          = var.db_resources.disk_size
  }

  host {
    zone      = var.zone
    subnet_id = yandex_vpc_subnet.default.id
    name      = "db-host"
  }
}

resource "yandex_mdb_mysql_database" "dev_db" {
  cluster_id = yandex_mdb_mysql_cluster.dev_db.id
  name       = var.db_name
}

resource "yandex_mdb_mysql_user" "dev_user" {
  cluster_id = yandex_mdb_mysql_cluster.dev_db.id
  name       = var.db_user
  password   = var.db_password
  
  permission {
    database_name = yandex_mdb_mysql_database.dev_db.name
    roles         = ["ALL"]
  }
}

# Outputs
#output "vm_external_ip" {
#  value       = yandex_compute_instance.webapp.network_interface.0.nat_ip_address
#  description = "External IP address of the VM"
#}

#output "registry_id" {
#  value       = yandex_container_registry.default.id
#  description = "Container Registry ID"
#}



