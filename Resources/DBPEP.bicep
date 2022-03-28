param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'

param databaseAccounts_tku_paoh_env_cosmosdb_name string = '${envPrefix1}-cosmosdb'

param privateEndpoints_tku_paoh_env_cosmosdb_env_pep_name string = '${envPrefix1}-cosmosdb-${environment}-pep'
param privateEndpoints_tku_paoh_env_cosmosdb_intra_pep_name string = '${envPrefix1}-cosmosdb-intra-pep'

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


resource databaseAccounts_tku_paoh_env_cosmosdb_name_resource 'Microsoft.DocumentDB/databaseAccounts@2021-07-01-preview' existing = {
  name: databaseAccounts_tku_paoh_env_cosmosdb_name
}


resource privateEndpoints_tku_paoh_env_cosmosdb_intra_pep_name_resource 'Microsoft.Network/privateEndpoints@2020-11-01' existing = {
  name: privateEndpoints_tku_paoh_env_cosmosdb_intra_pep_name
  scope: resourceGroup(subscriptionId, intraResourceGroupName)
}


resource privateEndpoints_tku_paoh_env_cosmosdb_env_pep_name_resource 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: privateEndpoints_tku_paoh_env_cosmosdb_env_pep_name
  location: 'westeurope'
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_tku_paoh_env_cosmosdb_env_pep_name
        properties: {
          privateLinkServiceId: databaseAccounts_tku_paoh_env_cosmosdb_name_resource.id
          groupIds: [
            'MongoDB'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: virtualNetworks_tku_paoh_env_virtualnetwork_name_default.id
    }
    customDnsConfigs: [
      {
        fqdn: '${envPrefix1}-cosmosdb.mongo.cosmos.azure.com'
        ipAddresses: [
          '10.0.0.6'
        ]
      }
      {
        fqdn: '${envPrefix1}-cosmosdb-westeurope.mongo.cosmos.azure.com'
        ipAddresses: [
          '10.0.0.119'
        ]
      }
    ]
  }
}
