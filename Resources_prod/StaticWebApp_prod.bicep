param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'
param domain string = 'palveluohjaaja.fi'


param staticSites_tku_paoh_env_webfront_name string = '${envPrefix1}-webfront'


resource staticSites_tku_paoh_env_webfront_name_resource 'Microsoft.Web/staticSites@2021-02-01' = {
  name: staticSites_tku_paoh_env_webfront_name
  location: 'West Europe'
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    repositoryUrl: 'https://dev.azure.com/turunkaupunki/VmPalvelukonsolidaatio/_git/WebFrontend'
    branch: 'dev'
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
  }
}


resource staticSites_tku_paoh_env_webfront_name_palveluohjaaja_fi 'Microsoft.Web/staticSites/customDomains@2021-02-01' = {
  parent: staticSites_tku_paoh_env_webfront_name_resource
  name: '${domain}'
  location: 'West Europe'
  properties: {}
}

resource staticSites_tku_paoh_env_webfront_name_www_palveluohjaaja_fi 'Microsoft.Web/staticSites/customDomains@2021-02-01' = {
  parent: staticSites_tku_paoh_env_webfront_name_resource
  name: 'www.${domain}'
  location: 'West Europe'
  properties: {}
}