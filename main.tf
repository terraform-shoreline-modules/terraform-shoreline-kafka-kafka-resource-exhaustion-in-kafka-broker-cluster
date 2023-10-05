terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kafka_resource_exhaustion_in_kafka_broker_cluster" {
  source    = "./modules/kafka_resource_exhaustion_in_kafka_broker_cluster"

  providers = {
    shoreline = shoreline
  }
}