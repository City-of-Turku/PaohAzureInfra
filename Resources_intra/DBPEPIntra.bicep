param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'

param routeTables_route_13to252_name string = 'route_13to252'

param virtualNetworks_vnet_13_palveluohjain_name string = 'vnet_13_palveluohjain'
param privateEndpoints_tku_paoh_env_cosmosdb_intra_pep_name string = '${envPrefix1}-cosmosdb-intra-pep'

param databaseAccounts_tku_paoh_env_cosmosdb_name string = '${envPrefix1}-cosmosdb'

resource routeTables_route_13to252_name_resource 'Microsoft.Network/routeTables@2020-11-01' existing = {
  name: routeTables_route_13to252_name
}

resource routeTables_route_13to252_name_aliverkosta_muurille 'Microsoft.Network/routeTables/routes@2020-11-01' existing = {
  parent: routeTables_route_13to252_name_resource
  name: 'aliverkosta_muurille'
}

resource virtualNetworks_vnet_13_palveluohjain_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: virtualNetworks_vnet_13_palveluohjain_name
}

resource virtualNetworks_vnet_13_palveluohjain_name_default 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  parent: virtualNetworks_vnet_13_palveluohjain_name_resource
  name: 'default'
}

resource virtualNetworks_vnet_13_palveluohjain_name_vnetpeer_13to252 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' existing = {
  parent: virtualNetworks_vnet_13_palveluohjain_name_resource
  name: 'vnetpeer_13to252'
}

resource databaseAccounts_tku_paoh_env_cosmosdb_name_resource 'Microsoft.DocumentDB/databaseAccounts@2021-07-01-preview' existing = {
  name: databaseAccounts_tku_paoh_env_cosmosdb_name
  scope: resourceGroup(subscriptionId, resourceGroupName)
}



resource virtualNetworks_vnet_13_palveluohjain_name_tku_paoh_env_cosmosdb_pep_subnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_vnet_13_palveluohjain_name_resource
  name: 'tku-paoh-${environment}-cosmosdb-pep-subnet'
  properties: {
    addressPrefix: '10.16.13.176/29'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}


resource privateEndpoints_tku_paoh_env_cosmosdb_intra_pep_name_resource 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: privateEndpoints_tku_paoh_env_cosmosdb_intra_pep_name
  location: 'westeurope'
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_tku_paoh_env_cosmosdb_intra_pep_name
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
      id: virtualNetworks_vnet_13_palveluohjain_name_tku_paoh_env_cosmosdb_pep_subnet.id
    }
    customDnsConfigs: [
      {
        fqdn: 'tku-paoh-${environment}-cosmosdb.mongo.cosmos.azure.com'
        ipAddresses: [
          '10.16.13.180'
        ]
      }
      {
        fqdn: 'tku-paoh-${environment}-cosmosdb-westeurope.mongo.cosmos.azure.com'
        ipAddresses: [
          '10.16.13.181'
        ]
      }
    ]
  }
}




