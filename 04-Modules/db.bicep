param uniqueKey string
param prefix string 
param tags object
param adminUsername string
@secure()
param adminPassword string
param allowPublicIps bool = false
param dbName string = 'ghostdb'

resource sqlServer 'Microsoft.DBforMySQL/flexibleServers@2024-10-01-preview' = {
  name: '${prefix}-mysql-${uniqueKey}'
  location: resourceGroup().location
  sku: {
    name: 'Standard_B1s'
    tier: 'Burstable'
  }
  properties: {
    createMode: 'Default'
    version: '8.0.21'
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    highAvailability: {
      mode: 'Disabled'
    }
    storage: {
      autoGrow: 'Enabled'
      iops: 360
      storageSizeGB: 20
    }
  }
  tags: tags
}

resource sqlDb 'Microsoft.DBforMySQL/flexibleServers/databases@2023-12-30' = {
  parent: sqlServer
  name: dbName
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}

var customFirewallRules = [
  {
    Name: 'AllowPublicIps'
    StartIpAddress: '0.0.0.0'
    EndIpAddress: '255.255.255.255'
    isPublic: true
  }
  {
    Name: 'AllowAzureIps'
    StartIpAddress: '0.0.0.0'
    EndIpAddress: '0.0.0.0'
    isPublic: false
  }
]

var applicableRules = filter(customFirewallRules, (rule, i) => !rule.isPublic || allowPublicIps) 


@batchSize(1)
resource firewallRules 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2023-12-30' = [for rule in applicableRules: {
  parent: sqlServer
  name: rule.Name
  properties: {
    startIpAddress: rule.StartIpAddress
    endIpAddress: rule.EndIpAddress
  }
}]

output hostname string = sqlServer.properties.fullyQualifiedDomainName

