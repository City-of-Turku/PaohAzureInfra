param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'

param virtualNetworks_tku_paoh_env_virtualnetwork_name string = '${envPrefix1}-virtualnetwork'
param privateDnsZones_privatelink_azurecr_io_name string = 'privatelink.azurecr.io'
param registries_tkupaohenvcontainerregistry_name string = '${envPrefix2}containerregistry'
param privateEndpoints_tku_paoh_env_containerregistryendpoint_name string = '${envPrefix1}-containerregistryendpoint'


resource virtualNetworks_tku_paoh_env_virtualnetwork_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: virtualNetworks_tku_paoh_env_virtualnetwork_name
}

resource virtualNetworks_tku_paoh_env_virtualnetwork_name_default 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  name: 'default'
  parent: virtualNetworks_tku_paoh_env_virtualnetwork_name_resource
}


resource registries_tkupaohenvcontainerregistry_name_resource 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: registries_tkupaohenvcontainerregistry_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true
    policies: {
      quarantinePolicy: {
        status: 'disabled'
      }
      trustPolicy: {
        type: 'Notary'
        status: 'disabled'
      }
      retentionPolicy: {
        days: 7
        status: 'disabled'
      }
      exportPolicy: {
        status: 'enabled'
      }
    }
    encryption: {
      status: 'disabled'
    }
    dataEndpointEnabled: false
    publicNetworkAccess: 'Enabled'
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled'
    anonymousPullEnabled: false
  }
}





resource privateDnsZones_privatelink_azurecr_io_name_resource 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZones_privatelink_azurecr_io_name
  location: 'global'
  properties: {
  }
}



resource privateDnsZones_privatelink_azurecr_io_name_tkupaohenvcontainerregistry 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_privatelink_azurecr_io_name_resource
  name: 'tkupaoh${environment}containerregistry'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: '10.0.0.5'
      }
    ]
  }
}

resource privateDnsZones_privatelink_azurecr_io_name_tkupaohenvcontainerregistry_westeurope_data 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_privatelink_azurecr_io_name_resource
  name: 'tkupaoh${environment}containerregistry.westeurope.data'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: '10.0.0.4'
      }
    ]
  }
}



resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_azurecr_io_name 'Microsoft.Network/privateDnsZones/SOA@2018-09-01' = {
  parent: privateDnsZones_privatelink_azurecr_io_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}



resource privateDnsZones_privatelink_azurecr_io_name_uchucyd545lay 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZones_privatelink_azurecr_io_name_resource
  name: '${environment}uchucyd545lay'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworks_tku_paoh_env_virtualnetwork_name_resource.id
    }
  }
}



