#!/bin/bash

# Script Config
CONFIG_PATH=./config.sh

# Source the configuration file
source $CONFIG_PATH

echo "Using Maven from: $MAVEN_PATH"
echo "Using JDK from: $JDK_PATH"

# Navigate to the project directory
cd $SOURCE_PATH || { echo "Failed to navigate to $SOURCE_PATH directory"; exit 1; }

# Set JAVA_HOME for this script
echo "Using JAVA_HOME set to: $JDK_PATH"
export JAVA_HOME=$JDK_PATH

# Check java version
echo "Checking Java version..."
"$JAVA_HOME/bin/java" -version  # Use JAVA_HOME to get the java version

# Check maven version
echo "Checking Maven version..."
"$MAVEN_PATH/bin/mvn" -v  # Use quotes for safety

# Ensure the M2_PATH directory exists
echo "Creating the $M2_PATH directory if it doesn't exist..."
mkdir -p "$M2_PATH"

# Clean and build the project using Maven with custom settings.xml
"$MAVEN_PATH/bin/mvn" -DskipTests -s "$M2_SETTING" clean install

# Check if Maven build was successful
if [ $? -eq 0 ]; then
    echo "Build successful."
else
    echo "Build failed."
    exit 1
fi
