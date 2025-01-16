# Unlock the full potential of Azure with Bicep!
Unlock the full potential of your Azure cloud environment with Bicep, Microsoft's powerful Infrastructure-as-Code (IaC) language. In this session, we'll explore how Bicep simplifies the deployment of Azure resources by offering a more intuitive and readable syntax compared to traditional JSON templates.

Whether you're new to Infrastructure-as-Code or looking to enhance your current deployment practices, this presentation will equip you with the knowledge and tools needed to streamline your Azure resource management using Bicep. Bring your questions and get ready to take your Azure deployments to the next level!

# Content
This repository has some basic examples that will help to showcase Bicep language features, and best practices.

> [Click here for slides!](slides/Bicep_walkthrough_slides.pdf)

# Requirements
1. Azure Subscription - https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account
1. Azure CLI - https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-cli 
1. Bicep Tools - https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install
1. Visual Studio Code - https://code.visualstudio.com/download
1. Visual Studio Code Bicep Extension - https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep

>  Reference:  https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install

# Before you start
1. Authenticate to Azure - https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli
1. Update `.env` file at the root of the project to provide the following:
   | VARIABLE | DESCRIPTION | SAMPLE VALUE | 
   |--|--|--|
   | ENV_TYPE | Type of environment to deploy. Only values supported are dev or prod. | dev |
   | ENV_PREFIX | Prefix to be used in the naming convention of resources for Azure. | bicep |
   | ENV_LOCATION | Location to be used when creating Azure Resources | useast2 |
   | ENV_SECRET_KEY | Name of secret that will the DB Password used for some scenarios | DBPassword |
   | ENV_SECRET_VALUE | Password to be used when creating Azure SQL Server resources in the demo | [guidelines](https://learn.microsoft.com/en-us/sql/relational-databases/security/password-policy?view=sql-server-ver16) |
   | ENV_DB_PASSWORD_SALT | Salt to be used when creating a random password for some MySQL Server resources in the demos. | ¯\\_(ツ)_/¯ |

# Extras
1. Azure Bicep Best Practices - https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/best-practices#resource-definitions
1. Azure Diagrams - https://azurediagrams.com/
1. Azure Resource Naming Guidelines - https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
1. Azure Verified Modules - https://azure.github.io/Azure-Verified-Modules/
1. Bicep Playground - https://azure.github.io/bicep/
