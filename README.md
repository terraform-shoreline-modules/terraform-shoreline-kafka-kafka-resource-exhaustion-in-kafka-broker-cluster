
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka Resource Exhaustion in Kafka Broker Cluster.
---

Resource exhaustion in Kafka broker cluster refers to a situation where the available resources such as CPU, memory, and disk space in a Kafka broker cluster are depleted. This could be caused by a sudden increase in traffic or a spike in the number of messages being processed by the brokers. When resources are exhausted, the Kafka cluster may stop functioning correctly, leading to downtime, data loss, and degraded performance. It is important to monitor the Kafka cluster's resource utilization and implement scaling strategies to prevent resource exhaustion incidents.

### Parameters
```shell
export KAFKA_BROKER_NODE="PLACEHOLDER"

export ZOOKEEPER_NODE="PLACEHOLDER"

export TOPIC_NAME="PLACEHOLDER"

export PATH_TO_LOG_FILE="PLACEHOLDER"

export NEW_BROKER_COUNT="PLACEHOLDER"

export KAFKA_CONFIG_DIRECTORY="PLACEHOLDER"

export KAFKA_HOME_DIRECTORY="PLACEHOLDER"
```

## Debug

### Check CPU and memory usage on all Kafka broker nodes
```shell
top
```

### Check disk space usage on all Kafka broker nodes
```shell
df -h
```

### Check network connection status between Kafka broker nodes
```shell
ping ${KAFKA_BROKER_NODE}
```

### Check the number of Kafka topics and partitions
```shell
kafka-topics --describe --zookeeper ${ZOOKEEPER_NODE}:2181
```

### Check the number of Kafka producers and consumers
```shell
kafka-consumer-groups --bootstrap-server ${KAFKA_BROKER_NODE}:9092 --list
```

### Check the number of Kafka messages in each topic and partition
```shell
kafka-run-class kafka.tools.GetOffsetShell --broker-list ${KAFKA_BROKER_NODE}:9092 --topic ${TOPIC_NAME} --time -1
```

### Check the Kafka log files for errors or warning messages
```shell
tail -f /var/log/kafka/kafka-server.log
```

### Check the Kafka broker configuration files for any misconfigurations
```shell
cat /etc/kafka/server.properties
```

### Sudden surge in incoming data traffic to the Kafka cluster.
```shell


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


```

## Repair

### Increase the number of Kafka brokers in the cluster to balance the load and prevent resource exhaustion.
```shell


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


```