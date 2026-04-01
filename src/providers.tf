terraform {
  required_version = "~>1.14.0"
  
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "=0.193.0"
    }
  }
  
  backend "s3" {
   bucket  = "dev-oll"
    key     = "terraform.tfstate"
    region  = "ru-central1"
    use_lockfile = true
    
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true

  }
}

provider "yandex" {
  zone = "ru-central1-a"
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
}

