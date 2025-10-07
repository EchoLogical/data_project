# Use OpenJDK 17 as the base image
FROM openjdk:17-slim-buster

# Add Maintainer Info
LABEL maintainer="faisal.amir@avrist.com"

# Define environment variables
ENV APP_NAME=blacklist.jar
ENV JAVA_SECURITY_PATH=/usr/local/openjdk-17/conf/security

# Set the working directory to /app
WORKDIR /app

# Copy the application JAR file into the container at /app
COPY target/${APP_NAME} /app/${APP_NAME}

# Copy java.security
COPY files/java.security ${JAVA_SECURITY_PATH}/java.security

# Run the command to start the Spring Boot application
CMD ["java", "-Dspring.profiles.active=prod", "-jar", "/app/blacklist.jar"]
