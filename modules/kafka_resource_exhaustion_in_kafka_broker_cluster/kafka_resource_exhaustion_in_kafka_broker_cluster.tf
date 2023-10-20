resource "shoreline_notebook" "kafka_resource_exhaustion_in_kafka_broker_cluster" {
  name       = "kafka_resource_exhaustion_in_kafka_broker_cluster"
  data       = file("${path.module}/data/kafka_resource_exhaustion_in_kafka_broker_cluster.json")
  depends_on = [shoreline_action.invoke_update_kafka_config_and_restart_service]
}

resource "shoreline_file" "update_kafka_config_and_restart_service" {
  name             = "update_kafka_config_and_restart_service"
  input_file       = "${path.module}/data/update_kafka_config_and_restart_service.sh"
  md5              = filemd5("${path.module}/data/update_kafka_config_and_restart_service.sh")
  description      = "Increase the memory and storage capacity of the Kafka broker cluster to prevent resource exhaustion."
  destination_path = "/tmp/update_kafka_config_and_restart_service.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_kafka_config_and_restart_service" {
  name        = "invoke_update_kafka_config_and_restart_service"
  description = "Increase the memory and storage capacity of the Kafka broker cluster to prevent resource exhaustion."
  command     = "`chmod +x /tmp/update_kafka_config_and_restart_service.sh && /tmp/update_kafka_config_and_restart_service.sh`"
  params      = ["NEW_STORAGE_SIZE","KAFKA_HOME_DIRECTORY","NEW_MEMORY_SIZE","BROKER_ID"]
  file_deps   = ["update_kafka_config_and_restart_service"]
  enabled     = true
  depends_on  = [shoreline_file.update_kafka_config_and_restart_service]
}

