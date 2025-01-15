@allowed([
  'dev'
  'prod'
])
param environmentType string = 'dev'
param location string = 'eastus2'
param prefix string 
@secure()
param dbPasswordSalt string

targetScope = 'subscription'

var tags = {
  environment: environmentType
  prefix: prefix
}

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${prefix}-04-${environmentType}'
  location: location
  tags: tags
}
var uniqueKey = uniqueString(rg.id)

var dbName = 'ghostdb'
var dbAdminUsername = 'db_admin'
var dbAdminPassword = uniqueString(uniqueKey, dbPasswordSalt)

module db 'db.bicep' = {
  name: 'db'
  scope: rg
  params: {
    uniqueKey: uniqueKey
    prefix: prefix
    dbName: dbName
    adminUsername: dbAdminUsername
    adminPassword: dbAdminPassword
    tags: tags
  }
}

module web 'web.bicep' = {
  name: 'web'
  scope: rg
  params: {
    uniqueKey: uniqueKey
    environmentType: environmentType
    prefix: prefix
    tags: tags
    dbHostname: db.outputs.hostname
    dbName: dbName
    dbAdminUsername: dbAdminUsername
    dbAdminPassword: dbAdminPassword
  }
}

output appServiceHostName string = web.outputs.defaultHostName
