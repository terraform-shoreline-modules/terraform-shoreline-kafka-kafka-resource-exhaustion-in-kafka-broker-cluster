resource "shoreline_notebook" "kafka_resource_exhaustion_in_kafka_broker_cluster" {
  name       = "kafka_resource_exhaustion_in_kafka_broker_cluster"
  data       = file("${path.module}/data/kafka_resource_exhaustion_in_kafka_broker_cluster.json")
  depends_on = [shoreline_action.invoke_kafka_traffic_monitor,shoreline_action.invoke_kafka_broker_config_update]
}

resource "shoreline_file" "kafka_traffic_monitor" {
  name             = "kafka_traffic_monitor"
  input_file       = "${path.module}/data/kafka_traffic_monitor.sh"
  md5              = filemd5("${path.module}/data/kafka_traffic_monitor.sh")
  description      = "Sudden surge in incoming data traffic to the Kafka cluster."
  destination_path = "/agent/scripts/kafka_traffic_monitor.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_broker_config_update" {
  name             = "kafka_broker_config_update"
  input_file       = "${path.module}/data/kafka_broker_config_update.sh"
  md5              = filemd5("${path.module}/data/kafka_broker_config_update.sh")
  description      = "Increase the number of Kafka brokers in the cluster to balance the load and prevent resource exhaustion."
  destination_path = "/agent/scripts/kafka_broker_config_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_kafka_traffic_monitor" {
  name        = "invoke_kafka_traffic_monitor"
  description = "Sudden surge in incoming data traffic to the Kafka cluster."
  command     = "`chmod +x /agent/scripts/kafka_traffic_monitor.sh && /agent/scripts/kafka_traffic_monitor.sh`"
  params      = ["TOPIC_NAME","KAFKA_BROKER_NODE","PATH_TO_LOG_FILE"]
  file_deps   = ["kafka_traffic_monitor"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_traffic_monitor]
}

resource "shoreline_action" "invoke_kafka_broker_config_update" {
  name        = "invoke_kafka_broker_config_update"
  description = "Increase the number of Kafka brokers in the cluster to balance the load and prevent resource exhaustion."
  command     = "`chmod +x /agent/scripts/kafka_broker_config_update.sh && /agent/scripts/kafka_broker_config_update.sh`"
  params      = ["KAFKA_CONFIG_DIRECTORY","KAFKA_HOME_DIRECTORY","NEW_BROKER_COUNT"]
  file_deps   = ["kafka_broker_config_update"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_broker_config_update]
}

