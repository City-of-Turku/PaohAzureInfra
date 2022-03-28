param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'


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

