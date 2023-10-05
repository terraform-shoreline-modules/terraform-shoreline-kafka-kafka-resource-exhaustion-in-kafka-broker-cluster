

#!/bin/bash



# Set the variables for the Kafka broker cluster

KAFKA_HOME=${KAFKA_HOME_DIRECTORY}

KAFKA_CONFIG=${KAFKA_CONFIG_DIRECTORY}

NEW_BROKER_COUNT=${NEW_BROKER_COUNT}



# Stop the Kafka broker service

$KAFKA_HOME/bin/kafka-server-stop.sh



# Update the Kafka configuration to include the new broker count

sed -i "s/broker\.id=.*$/broker.id=$NEW_BROKER_COUNT/g" $KAFKA_CONFIG/server.properties



# Start the Kafka broker service

$KAFKA_HOME/bin/kafka-server-start.sh -daemon $KAFKA_CONFIG/server.properties



# Verify that the new broker count has been updated

$KAFKA_HOME/bin/kafka-topics.sh --list --bootstrap-server localhost:9092