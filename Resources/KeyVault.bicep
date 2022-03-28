param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'

param vaults_tku_paoh_env_keyvault_name string = '${envPrefix1}-keyvault'


resource vaults_tku_paoh_env_keyvault_name_resource 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: vaults_tku_paoh_env_keyvault_name
  location: 'westeurope'
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: '6c5e2c8a-d3f0-4a0b-9658-42502c73e17b'
    accessPolicies: [
      {
        tenantId: '6c5e2c8a-d3f0-4a0b-9658-42502c73e17b'
        objectId: '6d849ac6-de7e-4a5b-8226-d9d9102e57ea'
        permissions: {
          keys: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'recover'
            'backup'
            'restore'
          ]
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'recover'
            'backup'
            'restore'
          ]
          certificates: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'recover'
            'backup'
            'restore'
            'managecontacts'
            'manageissuers'
            'getissuers'
            'listissuers'
            'setissuers'
            'deleteissuers'
          ]
        }
      }
      {
        tenantId: '6c5e2c8a-d3f0-4a0b-9658-42502c73e17b'
        objectId: 'c3761437-58cc-452f-9b2e-2706cea715d6'
        permissions: {
          keys: []
          secrets: [
            'get'
            'list'
          ]
          certificates: []
        }
      }
    ]
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: false
    vaultUri: 'https://${vaults_tku_paoh_env_keyvault_name}.vault.azure.net/'
    provisioningState: 'Succeeded'
  }
}



resource vaults_tku_paoh_env_keyvault_name_aksclustername 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'aksclustername'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_aksingressrooturl 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'aksingressrooturl'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_armconnection 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'armconnection'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_azurestorageaccountkey 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'azurestorageaccountkey'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_azurestorageaccountname 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'azurestorageaccountname'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_azuresubscription 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'azuresubscription'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_bfmongodb 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'bfmongodb'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_botfrontrooturl 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'botfrontrooturl'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_containerregistry 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'containerregistry'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_dockerregistryserverpassword 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'dockerregistryserverpassword'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_dockerregistryserverurl 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'dockerregistryserverurl'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_dockerregistryserverusername 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'dockerregistryserverusername'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_environment 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'environment'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_envprefix 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'envprefix'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_frontdoorid 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'frontdoorid'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_frontdoorrooturl 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'frontdoorrooturl'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_intramongohost 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'intramongohost'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_intramongoport 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'intramongoport'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_kompassiytrhost 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'kompassiytrhost'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_kompassiytrport 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'kompassiytrport'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_mongohost 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'mongohost'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_mongopassword 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'mongopassword'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_mongoport 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'mongoport'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_mongousername 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'mongousername'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_resourcegroup 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'resourcegroup'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_servicedbmongodb 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'servicedbmongodb'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vaults_tku_paoh_env_keyvault_name_staticwebappdeploymenttoken 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: vaults_tku_paoh_env_keyvault_name_resource
  name: 'staticwebappdeploymenttoken'
  properties: {
    attributes: {
      enabled: true
    }
  }
}






