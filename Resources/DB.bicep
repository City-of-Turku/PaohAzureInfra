param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'

param databaseAccounts_tku_paoh_env_cosmosdb_createMode string = 'Default'
param databaseAccounts_tku_paoh_env_cosmosdb_name string = '${envPrefix1}-cosmosdb'

param virtualNetworks_tku_paoh_env_virtualnetwork_name string = '${envPrefix1}-virtualnetwork'
param virtualNetworks_tku_paoh_intra_virtualnetwork_name string = 'vnet_13_palveluohjain'

resource virtualNetworks_tku_paoh_intra_virtualnetwork_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: virtualNetworks_tku_paoh_intra_virtualnetwork_name
  scope: resourceGroup(subscriptionId, intraResourceGroupName)
}

resource virtualNetworks_tku_paoh_intra_virtualnetwork_name_default 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  name: 'default'
  parent: virtualNetworks_tku_paoh_intra_virtualnetwork_name_resource
}

resource virtualNetworks_tku_paoh_env_virtualnetwork_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: virtualNetworks_tku_paoh_env_virtualnetwork_name
}

resource virtualNetworks_tku_paoh_env_virtualnetwork_name_default 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  name: 'default'
  parent: virtualNetworks_tku_paoh_env_virtualnetwork_name_resource
}



resource databaseAccounts_tku_paoh_env_cosmosdb_name_resource 'Microsoft.DocumentDB/databaseAccounts@2021-07-01-preview' = {
  name: databaseAccounts_tku_paoh_env_cosmosdb_name
  location: 'West Europe'
  tags: {
    defaultExperience: 'Azure Cosmos DB for MongoDB API'
    'hidden-cosmos-mmspecial': ''
  }
  kind: 'MongoDB'
  identity: {
    type: 'None'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: true
    virtualNetworkRules: [
      {
        id: virtualNetworks_tku_paoh_intra_virtualnetwork_name_default.id
        ignoreMissingVNetServiceEndpoint: true
      }
      {
        id: virtualNetworks_tku_paoh_env_virtualnetwork_name_default.id
        ignoreMissingVNetServiceEndpoint: true
      }
    ]
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: false
    enableAnalyticalStorage: false
    analyticalStorageConfiguration: {
      schemaType: 'FullFidelity'
    }
    databaseAccountOfferType: 'Standard'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    apiProperties: {
      serverVersion: '4.0'
    }
    locations: [
      {
        locationName: 'West Europe'
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    cors: []
    capabilities: [
      {
        name: 'EnableMongo'
      }
      {
        name: 'DisableRateLimitingResponses'
      }
      {
        name: 'EnableServerless'
      }
    ]
    ipRules: [
      {
        ipAddressOrRange: '81.175.255.179'
      }
      {
        ipAddressOrRange: '88.193.157.238'
      }
      {
        ipAddressOrRange: '104.42.195.92'
      }
      {
        ipAddressOrRange: '40.76.54.131'
      }
      {
        ipAddressOrRange: '52.176.6.30'
      }
      {
        ipAddressOrRange: '52.169.50.45'
      }
      {
        ipAddressOrRange: '52.187.184.26'
      }
    ]
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        backupStorageRedundancy: 'Geo'
      }
    }
    networkAclBypassResourceIds: []
    diagnosticLogSettings: {
      enableFullTextQuery: 'None'
    }
    createMode: databaseAccounts_tku_paoh_env_cosmosdb_createMode
  }
}


resource databaseAccounts_tku_paoh_env_cosmosdb_name_bf 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2021-07-01-preview' = {
  parent: databaseAccounts_tku_paoh_env_cosmosdb_name_resource
  name: 'bf'
  properties: {
    resource: {
      id: 'bf'
    }
  }
}

resource databaseAccounts_tku_paoh_env_cosmosdb_name_service_db 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2021-07-01-preview' = {
  parent: databaseAccounts_tku_paoh_env_cosmosdb_name_resource
  name: 'service_db'
  properties: {
    resource: {
      id: 'service_db'
    }
  }
}


