#!/bin/bash

# Function to replace placeholders with environment variables
replace_env_vars() {
    envsubst < /usr/app/proxy.properties.template > /usr/app/proxy.properties
}

# Replace environment variables in the properties file
replace_env_vars

# Run your application
exec java -jar /usr/app/kafkaproxy-1.0-SNAPSHOT-jar-with-dependencies.jar /usr/app/proxy.properties