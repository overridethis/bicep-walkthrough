@allowed([
  'dev'
  'prod'
])
@description('The environment type for the resources. (prod, dev)')
param environmentType string = 'dev'
@description('The environment prefix for all resources')
param prefix string 

@description('The keyvault to be used to get database password.')
param vaultName string
@description('The keyvault resource group to be used to get database password.')
param vaultResourceGroup string
@description('The keyvault to be used to get database password.')
param vaultPasswordSecretName string

var uniqueKey = uniqueString(resourceGroup().id)
var dbName = 'cms_db'
var dbAdminUsername = 'db_admin'

var tags = {
  environment: environmentType
  prefix: prefix
}

resource kv 'Microsoft.KeyVault/vaults@2024-04-01-preview' existing = {
  name: vaultName
  scope: resourceGroup(subscription().subscriptionId, vaultResourceGroup)
}

module db 'sql.bicep' = {
  name: 'db'
  params: {
    auditingEnabled: true
    environmentType: environmentType
    prefix: prefix
    dbLogin: dbAdminUsername
    dbPassword: kv.getSecret(vaultPasswordSecretName)
    dbName: dbName
    tags: tags
    uniqueKey: uniqueKey
  }
}
