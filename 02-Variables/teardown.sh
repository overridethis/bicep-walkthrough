#!/bin/bash

# Start at this script's directory to ensure relative paths are correct
cd "${0%/*}"

# configuration.
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX
[[ -z "$ENV_TYPE" ]] && echo -n "Enter the Environment Type to be used for all resources: " && read ENV_TYPE

# delete deployment stack
az stack group delete \
    --name $ENV_PREFIX-demo-02 \
    --resource-group rg-$ENV_PREFIX-02-$ENV_TYPE \
    --action-on-unmanage deleteAll \
    --yes

# delete resource group
az group delete \
    --resource-group rg-$ENV_PREFIX-02-$ENV_TYPE \
    --yes
