#!/bin/bash

# Start at this script's directory to ensure relative paths are correct
cd "${0%/*}"

# configuration
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX
[[ -z "$ENV_TYPE" ]] && echo -n "Enter the Environment Type to be used for all resources: " && read ENV_TYPE
[[ -z "$ENV_LOCATION" ]] && echo -n "Enter the Location where all resources are to be created: " && read ENV_LOCATION

# delete resource group.
az group delete --name rg-$ENV_PREFIX-vault-$ENV_TYPE --yes

# purge the key vault.
KEY_VAULT_NAME=kv-$ENV_PREFIX-$ENV_TYPE-$ENV_LOCATION
az keyvault purge --name $KEY_VAULT_NAME --location $ENV_LOCATION