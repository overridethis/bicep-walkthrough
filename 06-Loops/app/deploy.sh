#!/bin/bash

# configuration
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX
[[ -z "$ENV_TYPE" ]] && echo -n "Enter the Environment Type to be used for all resources: " && read ENV_TYPE
[[ -z "$ENV_LOCATION" ]] && echo -n "Enter the Location where all resources are to be created: " && read ENV_LOCATION

# create az resource group
az group create --name rg-$ENV_PREFIX-06-DevOps-$ENV_TYPE --location $ENV_LOCATION

# deploy bicep (with a deployment stack)
az stack group create \
    --name $ENV_PREFIX-demo-06 \
    --resource-group rg-$ENV_PREFIX-06-DevOps-$ENV_TYPE \
    --template-file main.bicep \
    --parameters environmentType=$ENV_TYPE prefix=$ENV_PREFIX \
    --deny-settings-mode None \
    --action-on-unmanage detachAll \
    --yes

# sleep for 5 seconds to allow the deployment to complete
sleep 5
ACR_LOGIN_SERVER=$(az stack group show --name $ENV_PREFIX-demo-06 --resource-group rg-$ENV_PREFIX-06-DevOps-$ENV_TYPE --query 'outputs.loginServer.value' --output tsv)

# deploy container.
cd ./src
docker build -t readfromenv:latest .
docker tag readfromenv:latest $ACR_LOGIN_SERVER/readfromenv
az acr login --name $ACR_LOGIN_SERVER
docker push $ACR_LOGIN_SERVER/readfromenv


