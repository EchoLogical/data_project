#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Run sh files
echo "Clone Spring core v1..."
sh $HOME/repo/provider-service/autobuild/spring_core/pipeline/clone_ssh.sh
echo "Install Spring core v1..."
sh $HOME/repo/provider-service/autobuild/spring_core/pipeline/install.sh
echo "Clean Spring core v1..."
sh $HOME/repo/provider-service/autobuild/spring_core/pipeline/clean.sh
echo "Clone provider service..."
sh $HOME/repo/provider-service/autobuild/provider/pipeline/clone_ssh.sh
echo "Build provider service..."
sh $HOME/repo/provider-service/autobuild/provider/pipeline/build.sh
echo "Deploy provider service..."
sh $HOME/repo/provider-service/autobuild/provider/pipeline/deploy.sh
echo "Clean provider service..."
sh $HOME/repo/provider-service/autobuild/provider/pipeline/clean.sh