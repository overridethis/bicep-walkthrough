// DEMO: 01 - Add target scope
// DEMO: 02 - Add storage account (showcase what-if)
// DEMO: 03 - Add blob container (showcase what-if)

targetScope = 'resourceGroup'

resource storage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: 'storage${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource blobs 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' existing = {
  parent: storage
  name: 'default'
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = [for i in range(0,3): {
  parent: blobs
  name: 'images${i}'
}]

