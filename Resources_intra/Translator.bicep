param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'

param virtualNetworks_vnet_13_palveluohjain_name string = 'vnet_13_palveluohjain'
param accounts_tku_paoh_intra_translator_name string = 'tku-paoh-intra-translator'

resource virtualNetworks_vnet_13_palveluohjain_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: virtualNetworks_vnet_13_palveluohjain_name
}

resource virtualNetworks_vnet_13_palveluohjain_name_default 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  parent: virtualNetworks_vnet_13_palveluohjain_name_resource
  name: 'default'
}

resource accounts_tku_paoh_intra_translator_name_resource 'Microsoft.CognitiveServices/accounts@2021-10-01' = {
  name: accounts_tku_paoh_intra_translator_name
  location: 'westeurope'
  sku: {
    name: 'F0'
  }
  kind: 'TextTranslation'
  identity: {
    type: 'None'
    userAssignedIdentities: {}
  }
  properties: {
    customSubDomainName: accounts_tku_paoh_intra_translator_name
    publicNetworkAccess: 'Enabled'
  }
}



