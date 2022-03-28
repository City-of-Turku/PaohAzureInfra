param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'


param storageAccounts_tkupaohenvstorage_name string = '${envPrefix2}storage'
param virtualNetworks_tku_paoh_env_virtualnetwork_name string = '${envPrefix1}-virtualnetwork'

resource virtualNetworks_tku_paoh_env_virtualnetwork_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: virtualNetworks_tku_paoh_env_virtualnetwork_name
}

resource virtualNetworks_tku_paoh_env_virtualnetwork_name_default 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  name: 'default'
  parent: virtualNetworks_tku_paoh_env_virtualnetwork_name_resource
}


resource storageAccounts_tkupaohenvstorage_name_resource 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccounts_tkupaohenvstorage_name
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAcls: {
      resourceAccessRules: []
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: virtualNetworks_tku_paoh_env_virtualnetwork_name_default.id
          action: 'Allow'
          state: 'Succeeded'
        }
      ]
      ipRules: [
        {
          value: '81.175.255.179'
          action: 'Allow'
        }
        {
          value: '193.64.225.83'
          action: 'Allow'
        }
      ]
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Cool'
  }
}



resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_tkupaohenvstorage_name_default 'Microsoft.Storage/storageAccounts/fileServices@2021-06-01' = {
  parent: storageAccounts_tkupaohenvstorage_name_resource
  name: 'default'
  properties: {
  }
}

resource storageAccounts_tkupaohenvstorage_name_default_fileshare_botfront_models 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-06-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_tkupaohenvstorage_name_default
  name: 'fileshare-botfront-models'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_tkupaohenvstorage_name_resource
  ]
}

resource storageAccounts_tkupaohenvstorage_name_default_fileshare_nlp_models 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-06-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_tkupaohenvstorage_name_default
  name: 'fileshare-nlp-models'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_tkupaohenvstorage_name_resource
  ]
}



resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_tkupaohenvstorage_name_default 'Microsoft.Storage/storageAccounts/queueServices@2021-06-01' = {
  parent: storageAccounts_tkupaohenvstorage_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_tkupaohenvstorage_name_default 'Microsoft.Storage/storageAccounts/tableServices@2021-06-01' = {
  parent: storageAccounts_tkupaohenvstorage_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource storageAccounts_tkupaohenvstorage_name_default_web 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  parent: storageAccounts_tkupaohenvstorage_name_default
  name: '$web'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_tkupaohenvstorage_name_resource
  ]
}


resource storageAccounts_tkupaohenvstorage_name_default_azure_webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  parent: storageAccounts_tkupaohenvstorage_name_default
  name: 'azure-webjobs-hosts'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_tkupaohenvstorage_name_resource
  ]
}

resource storageAccounts_tkupaohenvstorage_name_default 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  parent: storageAccounts_tkupaohenvstorage_name_resource
  name: 'default'
  properties: {
    changeFeed: {
      enabled: false
    }
    restorePolicy: {
      enabled: false
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    isVersioningEnabled: false
  }
}








