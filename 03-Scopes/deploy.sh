#!/bin/bash

# Start at this script's directory to ensure relative paths are correct
cd "${0%/*}"

# configuration
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX
[[ -z "$ENV_TYPE" ]] && echo -n "Enter the Environment Type to be used for all resources: " && read ENV_TYPE
[[ -z "$ENV_LOCATION" ]] && echo -n "Enter the Location where all resources are to be created: " && read ENV_LOCATION

# deploy bicep (with a deployment stack)
az stack sub create \
    --name $ENV_PREFIX-demo-03 \
    --template-file main.bicep \
    --location $ENV_LOCATION \
    --parameters environmentType=$ENV_TYPE prefix=$ENV_PREFIX \
    --deny-settings-mode denyWriteAndDelete \
    --action-on-unmanage detachAll \
    --yes