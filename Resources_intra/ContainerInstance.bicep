param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'

param virtualNetworks_vnet_13_palveluohjain_name string = 'vnet_13_palveluohjain'
param containerGroups_tku_paoh_intra_ytrservicedataimport_env_name string = 'tku-paoh-intra-ytrservicedataimport-${environment}'
param networkProfiles_tku_paoh_intra_ytrservicedataimport_env_networkProfile_name string = 'tku-paoh-intra-ytrservicedataimport-${environment}-networkProfile'


resource virtualNetworks_vnet_13_palveluohjain_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: virtualNetworks_vnet_13_palveluohjain_name
}

resource virtualNetworks_vnet_13_palveluohjain_name_default 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  parent: virtualNetworks_vnet_13_palveluohjain_name_resource
  name: 'default'
}


resource containerGroups_tku_paoh_intra_ytrservicedataimport_env_name_resource 'Microsoft.ContainerInstance/containerGroups@2021-07-01' = {
  name: containerGroups_tku_paoh_intra_ytrservicedataimport_env_name
  location: 'westeurope'
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: containerGroups_tku_paoh_intra_ytrservicedataimport_env_name
        properties: {
          image: 'tkupaoh${environment}containerregistry.azurecr.io/ytrservicedataimport:833'
          ports: [
            {
              protocol: 'TCP'
              port: 80
            }
          ]
          resources: {
            requests: {
              memoryInGB: 2
              cpu: 1
            }
          }
        }
      }
    ]
    initContainers: []
    imageRegistryCredentials: [
      {
        server: 'tkupaoh${environment}containerregistry.azurecr.io'
        username: 'tkupaoh${environment}containerregistry'
      }
    ]
    restartPolicy: 'Never'
    osType: 'Linux'
  }
}




resource networkProfiles_tku_paoh_intra_ytrservicedataimport_env_networkProfile_name_resource 'Microsoft.Network/networkProfiles@2020-11-01' = {
  name: networkProfiles_tku_paoh_intra_ytrservicedataimport_env_networkProfile_name
  location: 'westeurope'
  properties: {
    containerNetworkInterfaceConfigurations: [
      {
        name: 'eth0'
        properties: {
          ipConfigurations: [
            {
              name: 'ipconfigprofile1'
              properties: {
                subnet: {
                  id: virtualNetworks_vnet_13_palveluohjain_name_default.id
                }
              }
            }
          ]
        }
      }
    ]
  }
}



