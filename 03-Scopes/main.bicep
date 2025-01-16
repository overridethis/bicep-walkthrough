@allowed([
  'dev'
  'prod'
])
param environmentType string = 'dev'
param prefix string 

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${prefix}-03-${environmentType}'
  location: deployment().location
  tags: {
    environment: environmentType
    prefix: prefix
  }
}
