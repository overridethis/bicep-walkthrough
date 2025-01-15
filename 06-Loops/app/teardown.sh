# configuration.
[[ -z "$ENV_PREFIX" ]] && echo -n "Enter the Environment Prefix to be used for all resources: " && read ENV_PREFIX
[[ -z "$ENV_TYPE" ]] && echo -n "Enter the Environment Type to be used for all resources: " && read ENV_TYPE

# deploy bicep
az stack group delete \
    --name $ENV_PREFIX-demo-02 \
    --resource-group rg-$ENV_PREFIX-06-DevOps-$ENV_TYPE \
    --action-on-unmanage deleteAll \
    --yes

# create az resource group
az group delete \
    --resource-group rg-$ENV_PREFIX-06-DevOps-$ENV_TYPE \
    --yes