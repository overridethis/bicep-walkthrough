#!/bin/bash

# Start at this script's directory to ensure relative paths are correct
cd "${0%/*}"

# configuration
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX
[[ -z "$ENV_TYPE" ]] && echo -n "Enter the Environment Type to be used for all resources: " && read ENV_TYPE
[[ -z "$ENV_LOCATION" ]] && echo -n "Enter the Location where all resources are to be created: " && read ENV_LOCATION

# create az resource group
az group create --name rg-$ENV_PREFIX-02-$ENV_TYPE --location $ENV_LOCATION

# deploy bicep (with a deployment stack)
az stack group create \
    --name ${ENV_PREFIX}-demo-02 \
    --resource-group rg-$ENV_PREFIX-02-$ENV_TYPE \
    --template-file main.bicep \
    --parameters environmentType=$ENV_TYPE prefix=$ENV_PREFIX \
    --deny-settings-mode denyWriteAndDelete \
    --action-on-unmanage detachAll \
    --yes $1