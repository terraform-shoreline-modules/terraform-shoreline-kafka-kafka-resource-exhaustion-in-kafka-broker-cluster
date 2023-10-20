

#!/bin/bash



# Define variables

KAFKA_HOME=${KAFKA_HOME_DIRECTORY}

BROKER_ID=${BROKER_ID}

MEMORY_SIZE=${NEW_MEMORY_SIZE}

STORAGE_SIZE=${NEW_STORAGE_SIZE}



# Update the Kafka broker configuration file with new memory and storage sizes

sed -i "s/^broker.id=$BROKER_ID/broker.id=$BROKER_ID\nmessage.max.bytes=$MEMORY_SIZE\nlog.retention.bytes=$STORAGE_SIZE/g" $KAFKA_HOME/config/server.properties



# Restart the Kafka broker service

systemctl restart kafka