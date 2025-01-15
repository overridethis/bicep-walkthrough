@allowed([
  'dev'
  'prod'
])
@description('The environment type for the resources. (prod, dev)')
param environmentType string = 'dev'
@description('The environment prefix for all resources')
param prefix string 

targetScope='subscription'

var locations = [
  'centralus'
  'eastus2'
  'westus'
]

resource resourceGroups 'Microsoft.Resources/resourceGroups@2021-04-01' = [for location in locations: {
  name: 'rg-${prefix}-06-${environmentType}-${location}'
  location: location
}]

module webs 'web.bicep' = [for i in range(0, length(locations)): {
  scope: resourceGroups[i]
  name: 'web-${locations[i]}-${i}'
  params: {
    prefix: prefix
    environmentType: environmentType
  }
}]
