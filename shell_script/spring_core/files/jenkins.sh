#!/bin/bash

# Define SSH connection details
USERNAME="faisal"
PASSWORD="faisal212"
SERVER_ADDRESS="192.168.234.128"
SCRIPT_PATH="$1"

# Login via SSH and execute the script
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$SERVER_ADDRESS" "sh $SCRIPT_PATH"