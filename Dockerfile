#
# BUILD STAGE
#
FROM maven:3.6.0-jdk-11-slim AS build  
COPY src /usr/src/app/src  
COPY pom.xml /usr/src/app  
RUN mvn -f /usr/src/app/pom.xml clean package

#
# PACKAGE STAGE
#
FROM openjdk:11-jre-slim 
COPY --from=build /usr/src/app/target/kafkaproxy-1.0-SNAPSHOT-jar-with-dependencies.jar /usr/app/kafkaproxy-1.0-SNAPSHOT-jar-with-dependencies.jar

# install envsubst
RUN apt-get update && apt-get install gettext-base

ENV PROXY_LISTENERS=PLAINTEXT://localhost:9092 \
    PROXY_ADVERTISED_LISTENERS= \
    SOLACE_HOST=tcps://solace:55443 \
    SOLACE_VPN_NAME=public \
    SOLACE_SEPARATORS="_."

# Copy the script into the image
COPY entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

# Specify the command to run your entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

CMD ["java","-jar","/usr/app/kafkaproxy-1.0-SNAPSHOT-jar-with-dependencies.jar", "/usr/app/proxy.properties"]  