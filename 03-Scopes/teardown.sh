#!/bin/bash

# Start at this script's directory to ensure relative paths are correct
cd "${0%/*}"

# configuration
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX

# deploy bicep
az stack sub delete \
    --name $ENV_PREFIX-demo-03 \
    --action-on-unmanage deleteResources \
    --yes
