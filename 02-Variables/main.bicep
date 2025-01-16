// DEMO 01 - Add Parameters
// DEMO 02 - Add Variables
// DEMO 03 - Add App Service Plan, App Service and Lock resources (optional)
// DEMO 04 - Add Outputs 

@allowed([
  'dev'
  'prod'
])
@description('The environment type for the resources. (prod, dev)')
param environmentType string = 'dev'
@description('The environment prefix for all resources')
param prefix string

targetScope = 'resourceGroup'

var uniqueKey = uniqueString(resourceGroup().id)
var skuName = environmentType == 'prod' ? 'P2v3' : 'F1'
var skuTier = environmentType == 'prod' ? 'Premium' : 'Standard'

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: '${prefix}-appsvcplan-${uniqueKey}'
  location: resourceGroup().location
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    name: skuName
    tier: skuTier
  }
}

resource appServiceApp 'Microsoft.Web/sites@2023-12-01' = {
  name:  '${prefix}-appsvc-${uniqueKey}'
  location: resourceGroup().location
  kind: 'app,linux,container'  
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://index.docker.io' }
        { name: 'url', value: 'http://localhost:80' }
        { name: 'NODE_ENV', value: 'development' }
      ]
      linuxFxVersion: 'DOCKER|ghost:latest'
    }
  }
}

output appServiceAppName string = appServiceApp.name
output appServiceAppUrl string = 'https://${appServiceApp.properties.defaultHostName}'
