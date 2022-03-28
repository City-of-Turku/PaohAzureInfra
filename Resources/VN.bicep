param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'


param networkSecurityGroups_tku_paoh_env_nsg_name string = '${envPrefix1}-nsg'
param virtualNetworks_tku_paoh_env_virtualnetwork_name string = '${envPrefix1}-virtualnetwork'

resource networkSecurityGroups_tku_paoh_env_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: networkSecurityGroups_tku_paoh_env_nsg_name
  location: 'westeurope'
  properties: {
    securityRules: [
      {
        name: 'allowssh'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '22'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: [
            '81.175.255.179'
            '193.64.225.83'
            '80.223.30.166'
            '79.134.113.123'
          ]
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Port_443'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '0.0.0.0/0'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}


resource networkSecurityGroups_tku_paoh_env_nsg_name_allowssh 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  parent: networkSecurityGroups_tku_paoh_env_nsg_name_resource
  name: 'allowssh'
  properties: {
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '22'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 110
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: [
      '81.175.255.179'
      '193.64.225.83'
      '80.223.30.166'
      '79.134.113.123'
    ]
    destinationAddressPrefixes: []
  }
}

resource networkSecurityGroups_tku_paoh_env_nsg_name_Port_443 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  parent: networkSecurityGroups_tku_paoh_env_nsg_name_resource
  name: 'Port_443'
  properties: {
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: '0.0.0.0/0'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 120
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}



resource virtualNetworks_tku_paoh_env_virtualnetwork_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_tku_paoh_env_virtualnetwork_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroups_tku_paoh_env_nsg_name_resource.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                'westeurope'
                'northeurope'
              ]
            }
            {
              service: 'Microsoft.AzureCosmosDB'
              locations: [
                '*'
              ]
            }
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}


resource virtualNetworks_tku_paoh_env_virtualnetwork_name_default 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_tku_paoh_env_virtualnetwork_name_resource
  name: 'default'
  properties: {
    addressPrefix: '10.0.0.0/16'
    networkSecurityGroup: {
      id: networkSecurityGroups_tku_paoh_env_nsg_name_resource.id
    }
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
        locations: [
          'westeurope'
          'northeurope'
        ]
      }
      {
        service: 'Microsoft.AzureCosmosDB'
        locations: [
          '*'
        ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}