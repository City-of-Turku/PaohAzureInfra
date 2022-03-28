param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'

param connections_arm_name string = 'arm'
param workflows_tku_paoh_intra_logicapp_env_name string = 'tku-paoh-intra-logicapp-${environment}'

resource workflows_tku_paoh_intra_logicapp_env_name_resource 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_tku_paoh_intra_logicapp_env_name
  location: 'westeurope'
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        Recurrence: {
          recurrence: {
            frequency: 'Day'
            interval: 1
            schedule: {
              hours: [
                '2'
              ]
              minutes: [
                0
              ]
            }
          }
          evaluatedRecurrence: {
            frequency: 'Day'
            interval: 1
            schedule: {
              hours: [
                '2'
              ]
              minutes: [
                0
              ]
            }
          }
          type: 'Recurrence'
        }
      }
      actions: {
        Invoke_resource_operation: {
          runAfter: {}
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'arm\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/subscriptions/@{encodeURIComponent(\'313543fe-ab85-4ba0-8f49-6f0845adcbcf\')}/resourcegroups/@{encodeURIComponent(\'tku-palveluohjain-intra\')}/providers/@{encodeURIComponent(\'Microsoft.ContainerInstance\')}/@{encodeURIComponent(\'containerGroups/tku-paoh-intra-ytrservicedataimport-${environment}\')}/@{encodeURIComponent(\'start\')}'
            queries: {
              'x-ms-api-version': '2019-12-01'
            }
          }
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          arm: {
            connectionId: connections_arm_name_resource.id
            connectionName: 'arm'
            id: '/subscriptions/313543fe-ab85-4ba0-8f49-6f0845adcbcf/providers/Microsoft.Web/locations/westeurope/managedApis/arm'
          }
        }
      }
    }
  }
}

resource connections_arm_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_arm_name
  location: 'westeurope'
  kind: 'V1'
  properties: {
    displayName: 'joonas.itkonen@gofore.com'
    statuses: [
      {
        status: 'Connected'
      }
    ]
    customParameterValues: {}
    nonSecretParameterValues: {
      'token:TenantId': '6c5e2c8a-d3f0-4a0b-9658-42502c73e17b'
      'token:grantType': 'code'
    }
    createdTime: '8/31/2021 7:22:14 AM'
    changedTime: '11/2/2021 2:00:19 AM'
    api: {
      name: connections_arm_name
      displayName: 'Azure Resource Manager'
      description: 'Azure Resource Manager exposes the APIs to manage all of your Azure resources.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1514/1.0.1514.2551/${connections_arm_name}/icon.png'
      brandColor: '#003056'
      id: '/subscriptions/313543fe-ab85-4ba0-8f49-6f0845adcbcf/providers/Microsoft.Web/locations/westeurope/managedApis/${connections_arm_name}'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: []
  }
}
