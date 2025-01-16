resource storage_id 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: 'storage${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource storage_id_default_images_0_3 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = [
  for i in range(0, length(range(0, 3))): {
    name: 'storage${uniqueString(resourceGroup().id)}/default/images${range(0,3)[i]}'
    dependsOn: [
      storage_id
    ]
  }
]
