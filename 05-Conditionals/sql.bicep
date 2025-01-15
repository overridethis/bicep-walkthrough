@allowed([
  'dev'
  'prod'
])
@description('The environment type for the resources. (prod, dev)')
param environmentType string = 'dev'
@description('Audit Enabled (true/false)')
param auditingEnabled bool = false
@description('The environment prefix for all resources')
param prefix string 
@description('The administrator login username for the SQL server.')
param dbLogin string
@secure()
@description('The administrator login password for the SQL server.')
param dbPassword string
@description('The database name for the SQL server.')
param dbName string = 'cms_db'
param uniqueKey string
param tags object = {}

resource dbServer 'Microsoft.Sql/servers@2024-05-01-preview' = {
  name: '${prefix}-sqlsrv-${environmentType}-${uniqueKey}'
  location: resourceGroup().location
  properties: {
    administratorLogin: dbLogin
    administratorLoginPassword: dbPassword
  }
  tags: tags
}

resource db 'Microsoft.Sql/servers/databases@2024-05-01-preview' = {
  parent: dbServer
  name: dbName
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  tags: tags
}

resource auditStorage 'Microsoft.Storage/storageAccounts@2023-05-01' = if (auditingEnabled) {
  name: '${prefix}${environmentType}${uniqueKey}'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'  
}

resource sqlServerAudit 'Microsoft.Sql/servers/auditingSettings@2023-08-01-preview' = if (auditingEnabled) {
  parent: dbServer
  name: 'default'
  properties: {
    state: 'Enabled'
    storageEndpoint: auditStorage.properties.primaryEndpoints.blob
    storageAccountAccessKey: auditStorage.listKeys().keys[0].value
  }
}
