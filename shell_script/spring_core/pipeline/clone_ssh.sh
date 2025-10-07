#!/bin/bash

# Script to clone a git repository using global credentials

# Load environment variables from config.sh
CONFIG_PATH=./config.sh

# Source the configuration file
source $CONFIG_PATH

# Function to URL encode a string
url_encode() {
    local string="${1}"
    local encoded=""
    for ((i=0; i<${#string}; i++)); do
        local c="${string:i:1}"
        case "${c}" in
            [a-zA-Z0-9._~-]) encoded+="${c}" ;;  # Don't encode safe characters
            *) printf -v encoded '%s%%%02X' "$encoded" "'$c" ;;  # Encode special characters
        esac
    done
    echo "${encoded}"
}

# Check if required environment variables are set
if [[ -z "$GIT_USERNAME" || -z "$GIT_PASSWORD" || -z "$SOURCE_PATH" || -z "$REPO_URL" || -z "$BRANCH" ]]; then
    echo "Required environment variables are not set."
    exit 1
fi

# Clear git credentials
git config --global --unset user.name
git config --global --unset user.email
git config --global --unset credential.helper
git credential-cache exit

# URL encode the username and password
ENCODED_USERNAME=$(url_encode "$GIT_USERNAME")
ENCODED_PASSWORD=$(url_encode "$GIT_PASSWORD")

echo "Creating the $SOURCE_PATH directory if it doesn't exist..."
mkdir -p "$SOURCE_PATH"

echo "Cleaning the $SOURCE_PATH directory if it is not empty..."
if [ "$(ls -A "$SOURCE_PATH")" ]; then
    rm -rf -d "$SOURCE_PATH"  # Ensure contents are removed correctly
fi

# Ensure that the CORE_SOURCE_PATH is empty
if [ "$(ls -A "$SOURCE_PATH")" ]; then
    echo "Failed to clear the $SOURCE_PATH directory."
    exit 1
fi

echo "Cloning $BRANCH from git@$REPO_URL into $SOURCE_PATH..."
git clone -b "$BRANCH" "git@$REPO_URL" "$SOURCE_PATH"
if [ $? -eq 0 ]; then
    echo "Repository cloned successfully."
else
    echo "Failed to clone the repository."
    exit 1
fi

echo "Clone process finished."
