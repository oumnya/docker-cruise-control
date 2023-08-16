#!/bin/bash
set -e

cd /opt/cruise-control

# Set heap memory settings for container environments
if [ -z "${KAFKA_HEAP_OPTS}" ]; then
  export KAFKA_HEAP_OPTS="-XX:InitialRAMPercentage=75 -XX:MinRAMPercentage=75 -XX:MaxRAMPercentage=75"
fi

if [ -z "${KAFKA_OPTS}" ]; then
  export KAFKA_OPTS="-Dsun.net.inetaddr.ttl=60"
fi

# Default configuration file path
CONFIG_FILE="/opt/cruise-control/config/cruisecontrol.properties"

# If a path argument is provided, use that as the configuration file path
if [ "$#" -gt 0 ]; then
    CONFIG_FILE="$1"
fi

# If CRUISE_CONTROL_PROPERTIES_CONTENT is set, overwrite the default file
if [ ! -z "$CRUISE_CONTROL_PROPERTIES_CONTENT" ]; then
    echo "$CRUISE_CONTROL_PROPERTIES_CONTENT" > $CONFIG_FILE
fi

# Execute the Kafka Cruise Control process
exec "/opt/cruise-control/kafka-cruise-control-start.sh" $CONFIG_FILE 8090
