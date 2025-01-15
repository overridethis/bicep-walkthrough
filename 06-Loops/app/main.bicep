@description('Provide a prefix for the name of the registry.')
param prefix string = 'bicep'

@description('Provide a tier of your Azure Container Registry.')
param acrSku string = 'Basic'

@allowed([
  'dev'
  'prod'
])
param environmentType string = 'dev'

var uniqueKey = uniqueString(resourceGroup().id)

resource acrResource 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: 'acr${prefix}devops${environmentType}${uniqueKey}'
  location: resourceGroup().location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: false
  }
}


@description('Output the login server property for later use')
output loginServer string = acrResource.properties.loginServer
