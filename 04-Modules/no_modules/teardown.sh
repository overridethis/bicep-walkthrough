#!/bin/bash

# Start at this script's directory to ensure relative paths are correct
cd "${0%/*}"

# configuration
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX

# deploy bicep
az stack group delete \
    --name $ENV_PREFIX-demo-04 \
    --resource-group rg-$ENV_PREFIX-04-no_modules-$ENV_TYPE \
    --action-on-unmanage deleteAll \
    --yes

# create az resource group
az group delete \
    --resource-group rg-$ENV_PREFIX-04-no_modules-$ENV_TYPE \
    --yes
