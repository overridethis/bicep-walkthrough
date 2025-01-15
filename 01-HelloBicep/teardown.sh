#!/bin/bash

# Start at this script's directory to ensure relative paths are correct
cd "${0%/*}"

# variables
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX

# deploy bicep
az deployment group delete \
    --name $ENV_PREFIX-demo-01 \
    --resource-group rg-$ENV_PREFIX-01-dev

# create az resource group
az group delete \
    --resource-group rg-$ENV_PREFIX-01-dev \
    --yes
