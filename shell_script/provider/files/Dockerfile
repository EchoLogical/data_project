# For Java 11, try this
FROM adoptopenjdk/openjdk11:alpine-jre

# Refer to Maven build -> finalName
ARG JAR_FILE=app.jar

WORKDIR /app

COPY ${JAR_FILE} /app/${JAR_FILE}

CMD ["java", "-jar", "app.jar"]