# Migrating to Bicep from ARM Templates
If you already have an investment into Azure Resource Manager (ARM) templates you can migrate by running the decompile functionality provided by the Azure CLI.

```bash
az bicep decompile --file main.json --force
```

> Reference: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/decompile?tabs=azure-cli