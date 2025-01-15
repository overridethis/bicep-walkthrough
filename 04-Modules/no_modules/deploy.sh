#!/bin/bash

# Start at this script's directory to ensure relative paths are correct
cd "${0%/*}"

# configuration
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX
[[ -z "$ENV_TYPE" ]] && echo -n "Enter the Environment Type to be used for all resources: " && read ENV_TYPE
[[ -z "$ENV_LOCATION" ]] && echo -n "Enter the Location where all resources are to be created: " && read ENV_LOCATION
[[ -z "$ENV_DB_PASSWORD_SALT" ]] && echo -n "Enter the Environment DB Password Salt: " && read ENV_DB_PASSWORD_SALT

# create az resource group
az group create --name rg-$ENV_PREFIX-04-no_modules-$ENV_TYPE --location $ENV_LOCATION

# deploy bicep (with a deployment stack)
az stack group create \
    --name $ENV_PREFIX-demo-04 \
    --resource-group rg-$ENV_PREFIX-04-no_modules-$ENV_TYPE \
    --template-file main.bicep \
    --parameters environmentType=$ENV_TYPE prefix=$ENV_PREFIX dbPasswordSalt=$ENV_DB_PASSWORD_SALT \
    --deny-settings-mode none \
    --action-on-unmanage detachAll \
    --yes