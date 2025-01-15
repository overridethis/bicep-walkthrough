@allowed([
  'dev'
  'prod'
])
param environmentType string = 'dev'
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

// Reference (Kind property)
// https://github.com/Azure/app-service-linux-docs/blob/master/Things_You_Should_Know/kind_property.md#app-service-resource-kind-reference
  
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

resource lock 'Microsoft.Authorization/locks@2016-09-01' = {
  name: '${prefix}-lock-${uniqueKey}'
  scope: appServiceApp
  properties: {
    level: 'CanNotDelete'
  }
}

output appServiceAppName string = appServiceApp.name
output appServiceAppUrl string = 'https://${appServiceApp.properties.defaultHostName}'
