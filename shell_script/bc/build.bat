#!/bin/bash

echo "Java version:"
java -version

echo "Maven version:"
mvn --version

echo "Clean buiild..."
mvn clean install -DskipTests

echo "Packaging spring boot application..."
mvn -pl app-endpoint -am clean package spring-boot:repackage
