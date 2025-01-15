#!/bin/bash

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
