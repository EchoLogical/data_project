#!/bin/bash

# Load environment variables from config.sh
CONFIG_PATH=./config.sh

# Source the configuration file
source $CONFIG_PATH

# delete source code
echo "Cleaning $SOURCE_PATH..."
rm -rf -d $SOURCE_PATH