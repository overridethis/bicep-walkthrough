#!/bin/bash

# Start at this script's directory to ensure relative paths are correct
cd "${0%/*}"

# variables
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX
[[ -z "$ENV_LOCATION" ]] && echo -n "Enter the Location where all resources are to be created: " && read ENV_LOCATION

# create az resource group
az group create --name rg-$ENV_PREFIX-01-dev --location $ENV_LOCATION

# create deployment to resource group
az deployment group create \
    --name $ENV_PREFIX-demo-01 \
    --resource-group rg-$ENV_PREFIX-01-dev \
    --template-file main.bicep $1

