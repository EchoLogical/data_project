#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Source the environment variables
echo "locating config file $(pwd)/config.env.sh"
if [ -f "$(pwd)/config.env.sh" ]; then
    source "$(pwd)/config.env.sh"
else
    echo "Error: config.env.sh file not found"
    exit 1
fi

echo "Environment variables for Docker container:"
echo "DB_CNC_HOST: $(docker exec $CONTAINER_NAME printenv DB_CNC_HOST)"
echo "DB_CNC_PORT: $(docker exec $CONTAINER_NAME printenv DB_CNC_PORT)"
echo "DB_CNC_NAME: $(docker exec $CONTAINER_NAME printenv DB_CNC_NAME)"
echo "DB_CNC_USERNAME: $(docker exec $CONTAINER_NAME printenv DB_CNC_USERNAME)"
echo "DB_CNC_PASSWORD: $(docker exec $CONTAINER_NAME printenv DB_CNC_PASSWORD)"
echo "DB_AMSSEC_HOST: $(docker exec $CONTAINER_NAME printenv DB_AMSSEC_HOST)"
echo "DB_AMSSEC_PORT: $(docker exec $CONTAINER_NAME printenv DB_AMSSEC_PORT)"
echo "DB_AMSSEC_NAME: $(docker exec $CONTAINER_NAME printenv DB_AMSSEC_NAME)"
echo "DB_AMSSEC_USERNAME: $(docker exec $CONTAINER_NAME printenv DB_AMSSEC_USERNAME)"
echo "DB_AMSSEC_PASSWORD: $(docker exec $CONTAINER_NAME printenv DB_AMSSEC_PASSWORD)"
echo "CACHE_REDIS_HOST: $(docker exec $CONTAINER_NAME printenv CACHE_REDIS_HOST)"
echo "CACHE_REDIS_PORT: $(docker exec $CONTAINER_NAME printenv CACHE_REDIS_PORT)"
echo "AMSSEC_SECRET_KEY: $(docker exec $CONTAINER_NAME printenv AMSSEC_SECRET_KEY)"
echo "AMSSEC_ENDPOINT: $(docker exec $CONTAINER_NAME printenv AMSSEC_ENDPOINT)"
echo "AMSSEC_USERNAME: $(docker exec $CONTAINER_NAME printenv AMSSEC_USERNAME)"
echo "AMSSEC_PASSWORD: $(docker exec $CONTAINER_NAME printenv AMSSEC_PASSWORD)"
echo "AMSSEC_PARTNER_CODE: $(docker exec $CONTAINER_NAME printenv AMSSEC_PARTNER_CODE)"
echo "AMSSEC_DEVICE_TYPE: $(docker exec $CONTAINER_NAME printenv AMSSEC_DEVICE_TYPE)"
echo "NSSSEC_SECRET_KEY: $(docker exec $CONTAINER_NAME printenv NSSSEC_SECRET_KEY)"
echo "LDAP_BASE: $(docker exec $CONTAINER_NAME printenv LDAP_BASE)"
echo "LDAP_URL: $(docker exec $CONTAINER_NAME printenv LDAP_URL)"
echo "LDAP_USERNAME: $(docker exec $CONTAINER_NAME printenv LDAP_USERNAME)"
echo "LDAP_PASSWORD: $(docker exec $CONTAINER_NAME printenv LDAP_PASSWORD)"