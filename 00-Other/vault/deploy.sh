#!/bin/bash

# Start at this script's directory to ensure relative paths are correct
cd "${0%/*}"

# configuration
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX
[[ -z "$ENV_TYPE" ]] && echo -n "Enter the Environment Type to be used for all resources: " && read ENV_TYPE
[[ -z "$ENV_LOCATION" ]] && echo -n "Enter the Location where all resources are to be created: " && read ENV_LOCATION
[[ -z "$ENV_SECRET_KEY" ]] && echo -n "Enter the secret name to store in the Vault: " && read ENV_SECRET_KEY
[[ -z "$ENV_SECRET_VALUE" ]] && echo -n "Enter the secret value to store in the Vault: " && read ENV_SECRET_VALUE

# add resource group.
RESOURCE_GROUP_NAME=rg-$ENV_PREFIX-vault-$ENV_TYPE
az group create --name $RESOURCE_GROUP_NAME --location $ENV_LOCATION

# ad key vault.
KEY_VAULT_NAME=kv-$ENV_PREFIX-$ENV_TYPE-$ENV_LOCATION
az keyvault create \
  --name $KEY_VAULT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --location $ENV_LOCATION \
  --enabled-for-template-deployment true

# assign access to the caller.
CALLER_ID=$(az ad signed-in-user show --query id -o tsv)
KEY_VAULT_SCOPE=$(az keyvault show --name $KEY_VAULT_NAME --resource-group $RESOURCE_GROUP_NAME --query id -o tsv)
az role assignment create --assignee "$CALLER_ID" \
    --role "Key Vault Administrator" \
    --scope $KEY_VAULT_SCOPE

# add secret to vault.
sleep 10
az keyvault secret set --vault-name $KEY_VAULT_NAME --name $ENV_SECRET_KEY --value $ENV_SECRET_VALUE