@allowed([
  'dev'
  'prod'
])
param environmentType string = 'dev'
param prefix string 
@secure()
param dbPasswordSalt string

targetScope = 'resourceGroup'

var uniqueKey = uniqueString(resourceGroup().id)
var skuName = environmentType == 'prod' ? 'P2v3' : 'F1'
var skuTier = environmentType == 'prod' ? 'Premium' : 'Standard'
var tags = {
  environment: environmentType
  prefix: prefix
}

var dbName = 'ghostdb'
var dbAdminUsername = 'db_admin'
var dbAdminPassword = uniqueString(uniqueKey, dbPasswordSalt)

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
  tags: tags
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
        { name: 'NODE_ENV', value: 'development' }
        { name: 'url', value: 'http://localhost:80' }
        { name: 'database__client', value: 'mysql' }
        { name: 'database__connection__host', value: sqlServer.properties.fullyQualifiedDomainName }
        { name: 'database__connection__user', value: dbAdminUsername }
        { name: 'database__connection__password', value: dbAdminPassword }
        { name: 'database__connection__database', value: dbName }
        { name: 'database__connection__ssl__ca', value: '''
-----BEGIN CERTIFICATE-----
MIIDrzCCApegAwIBAgIQCDvgVpBCRrGhdWrJWZHHSjANBgkqhkiG9w0BAQUFADBh
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSAwHgYDVQQDExdEaWdpQ2VydCBHbG9iYWwgUm9vdCBD
QTAeFw0wNjExMTAwMDAwMDBaFw0zMTExMTAwMDAwMDBaMGExCzAJBgNVBAYTAlVT
MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
b20xIDAeBgNVBAMTF0RpZ2lDZXJ0IEdsb2JhbCBSb290IENBMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4jvhEXLeqKTTo1eqUKKPC3eQyaKl7hLOllsB
CSDMAZOnTjC3U/dDxGkAV53ijSLdhwZAAIEJzs4bg7/fzTtxRuLWZscFs3YnFo97
nh6Vfe63SKMI2tavegw5BmV/Sl0fvBf4q77uKNd0f3p4mVmFaG5cIzJLv07A6Fpt
43C/dxC//AH2hdmoRBBYMql1GNXRor5H4idq9Joz+EkIYIvUX7Q6hL+hqkpMfT7P
T19sdl6gSzeRntwi5m3OFBqOasv+zbMUZBfHWymeMr/y7vrTC0LUq7dBMtoM1O/4
gdW7jVg/tRvoSSiicNoxBN33shbyTApOB6jtSj1etX+jkMOvJwIDAQABo2MwYTAO
BgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUA95QNVbR
TLtm8KPiGxvDl7I90VUwHwYDVR0jBBgwFoAUA95QNVbRTLtm8KPiGxvDl7I90VUw
DQYJKoZIhvcNAQEFBQADggEBAMucN6pIExIK+t1EnE9SsPTfrgT1eXkIoyQY/Esr
hMAtudXH/vTBH1jLuG2cenTnmCmrEbXjcKChzUyImZOMkXDiqw8cvpOp/2PV5Adg
06O/nVsJ8dWO41P0jmP6P6fbtGbfYmbW0W5BjfIttep3Sp+dWOIrWcBAI+0tKIJF
PnlUkiaY4IBIqDfv8NZ5YBberOgOzW6sRBc4L0na4UU+Krk2U886UAb3LujEV0ls
YSEY1QSteDwsOoBrp+uvFRTp2InBuThs4pFsiv9kuXclVzDAGySj4dzp30d8tbQk
CAUw7C29C79Fv1C5qfPrmAESrciIxpg0X40KPMbp1ZWVbd4=
-----END CERTIFICATE-----'''}
      ]
      linuxFxVersion: 'DOCKER|ghost:latest'
    }
  }
  tags: tags
}

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
    administratorLogin: dbAdminUsername
    administratorLoginPassword: dbAdminPassword
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
  }
  {
    Name: 'AllowAzureIps'
    StartIpAddress: '0.0.0.0'
    EndIpAddress: '0.0.0.0'
  }
]

@batchSize(1)
resource firewallRules 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2023-12-30' = [for rule in customFirewallRules: {
  parent: sqlServer
  name: rule.Name
  properties: {
    startIpAddress: rule.StartIpAddress
    endIpAddress: rule.EndIpAddress
  }
}]


output appServiceAppName string = appServiceApp.name
output appServiceAppUrl string = 'https://${appServiceApp.properties.defaultHostName}'
