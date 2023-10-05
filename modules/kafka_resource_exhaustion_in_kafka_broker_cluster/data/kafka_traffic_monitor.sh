

#!/bin/bash



# Define variables

DATE=$(date +%Y-%m-%d)

LOG_FILE="${PATH_TO_LOG_FILE}"

THRESHOLD=100

CURRENT_TRAFFIC=$(kafka-run-class kafka.tools.JmxTool --object-name "kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec,topic=${TOPIC_NAME}" --jmx-url services:jmx:rmi:///jndi/rmi://${KAFKA_BROKER_NODE}:9999/jmxrmi --broker_id 0 | grep "Value =" | awk '{print $3}')

# Check if current traffic is above threshold

if [ "$CURRENT_TRAFFIC" -gt "$THRESHOLD" ]; then

    echo "There has been a sudden surge in incoming data traffic to the Kafka cluster."

    echo "Current traffic: $CURRENT_TRAFFIC"

    echo "Threshold: $THRESHOLD"

    # Check if Kafka broker cluster is running

    if ps aux | grep -q "[k]afka"; then

        echo "Kafka broker cluster is running."

        # Check CPU and memory usage of Kafka broker cluster

        TOP_OUTPUT=$(top -bn1 | grep "kafka")

        CPU_USAGE=$(echo "$TOP_OUTPUT" | awk '{print $9}')

        MEM_USAGE=$(echo "$TOP_OUTPUT" | awk '{print $10}')

        echo "CPU usage: $CPU_USAGE%"

        echo "Memory usage: $MEM_USAGE%"

        # Check if network bandwidth is sufficient

        NETSTAT_OUTPUT=$(netstat -s | grep "segments received")

        SEGMENTS_RECEIVED=$(echo "$NETSTAT_OUTPUT" | awk '{print $1}')

        if [ "$SEGMENTS_RECEIVED" -gt "$THRESHOLD" ]; then

            echo "Network bandwidth might be a bottleneck."

            echo "Segments received: $SEGMENTS_RECEIVED"

        else

            echo "Network bandwidth is not a bottleneck."

        fi

    else

        echo "Kafka broker cluster is not running."

    fi

else

    echo "Current traffic is within normal range."

    echo "Current traffic: $CURRENT_TRAFFIC"

    echo "Threshold: $THRESHOLD"

fi