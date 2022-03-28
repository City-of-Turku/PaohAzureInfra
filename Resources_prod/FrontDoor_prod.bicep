param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'

param frontdoors_palveluohjain_env_frontdoor_name string = 'palveluohjain-${environment}-frontdoor'
param frontdoorwebapplicationfirewallpolicies_tkupaohenvwafpolicy_name string = 'tkupaoh${environment}wafpolicy'


resource frontdoorwebapplicationfirewallpolicies_tkupaohenvwafpolicy_name_resource 'Microsoft.Network/frontdoorwebapplicationfirewallpolicies@2020-11-01' = {
  name: frontdoorwebapplicationfirewallpolicies_tkupaohenvwafpolicy_name
  location: 'Global'
  sku: {
    name: 'Classic_AzureFrontDoor'
  }
  properties: {
    policySettings: {
      enabledState: 'Enabled'
      mode: 'Detection'
      customBlockResponseStatusCode: 403
      customBlockResponseBody: 'VW5hdXRob3JpemVk'
      requestBodyCheck: 'Disabled'
    }
    customRules: {
      rules: [
        {
          name: 'tkupaoh${environment}wafrule'
          enabledState: 'Enabled'
          priority: 100
          ruleType: 'MatchRule'
          rateLimitDurationInMinutes: 1
          rateLimitThreshold: 100
          matchConditions: [
            {
              matchVariable: 'RemoteAddr'
              operator: 'IPMatch'
              negateCondition: false
              matchValue: [
                '0.0.0.0/0'
              ]
              transforms: []
            }
          ]
          action: 'Allow'
        }
      ]
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'DefaultRuleSet'
          ruleSetVersion: '1.0'
          ruleGroupOverrides: []
          exclusions: []
        }
      ]
    }
  }
}



resource frontdoors_palveluohjain_env_frontdoor_name_resource 'Microsoft.Network/frontdoors@2020-05-01' = {
  name: frontdoors_palveluohjain_env_frontdoor_name
  location: 'Global'
  properties: {
    routingRules: [
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/RoutingRules/tku-paoh-${environment}-frontdoorrule'
        name: 'tku-paoh-${environment}-frontdoorrule'
        properties: {
          routeConfiguration: {
            forwardingProtocol: 'HttpsOnly'
            backendPool: {
              id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/BackendPools/tku-paoh-${environment}-frontdoorbackendpool'
            }
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
          }
          frontendEndpoints: [
            {
              id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/FrontendEndpoints/${frontdoors_palveluohjain_env_frontdoor_name}-azurefd-net'
            }
          ]
          acceptedProtocols: [
            'Https'
          ]
          patternsToMatch: [
            '/*'
          ]
          enabledState: 'Enabled'
        }
      }
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/RoutingRules/tku-paoh-${environment}-frontdoorrule-httpredirect'
        name: 'tku-paoh-${environment}-frontdoorrule-httpredirect'
        properties: {
          routeConfiguration: {
            redirectType: 'Found'
            redirectProtocol: 'HttpsOnly'
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorRedirectConfiguration'
          }
          frontendEndpoints: [
            {
              id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/FrontendEndpoints/${frontdoors_palveluohjain_env_frontdoor_name}-azurefd-net'
            }
            {
              id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/frontendendpoints/www-palveluohjaaja-fi'
            }
            {
              id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/frontendendpoints/botfront-palveluohjaaja-fi'
            }
          ]
          acceptedProtocols: [
            'Http'
          ]
          patternsToMatch: [
            '/*'
          ]
          enabledState: 'Enabled'
        }
      }
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/RoutingRules/tku-paoh-${environment}-frontdoorrule-wa'
        name: 'tku-paoh-${environment}-frontdoorrule-wa'
        properties: {
          routeConfiguration: {
            forwardingProtocol: 'HttpsOnly'
            backendPool: {
              id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/BackendPools/tku-paoh-${environment}-frontdoorbackendpool-wa'
            }
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
          }
          frontendEndpoints: [
            {
              id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/frontendendpoints/www-palveluohjaaja-fi'
            }
          ]
          acceptedProtocols: [
            'Https'
          ]
          patternsToMatch: [
            '/*'
          ]
          enabledState: 'Enabled'
        }
      }
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/RoutingRules/tku-paoh-${environment}-frontdoorrule-botfront'
        name: 'tku-paoh-${environment}-frontdoorrule-botfront'
        properties: {
          routeConfiguration: {
            forwardingProtocol: 'HttpsOnly'
            backendPool: {
              id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/BackendPools/tku-paoh-${environment}-frontdoorbackendpool'
            }
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
          }
          frontendEndpoints: [
            {
              id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/frontendendpoints/botfront-palveluohjaaja-fi'
            }
          ]
          acceptedProtocols: [
            'Https'
          ]
          patternsToMatch: [
            '/*'
          ]
          enabledState: 'Enabled'
        }
      }
    ]
    loadBalancingSettings: [
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/LoadBalancingSettings/loadBalancingSettings-1634724196655'
        name: 'loadBalancingSettings-1634724196655'
        properties: {
          sampleSize: 4
          successfulSamplesRequired: 2
          additionalLatencyMilliseconds: 0
        }
      }
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/LoadBalancingSettings/loadBalancingSettings-1635158028884'
        name: 'loadBalancingSettings-1635158028884'
        properties: {
          sampleSize: 4
          successfulSamplesRequired: 2
          additionalLatencyMilliseconds: 0
        }
      }
    ]
    healthProbeSettings: [
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/HealthProbeSettings/healthProbeSettings-1634724196655'
        name: 'healthProbeSettings-1634724196655'
        properties: {
          path: '/palveluohjain-${environment}-aks.westeurope.cloudapp.azure.com/servicematcher'
          protocol: 'Https'
          intervalInSeconds: 30
          enabledState: 'Enabled'
          healthProbeMethod: 'HEAD'
        }
      }
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/HealthProbeSettings/healthProbeSettings-1635158028884'
        name: 'healthProbeSettings-1635158028884'
        properties: {
          path: '/'
          protocol: 'Https'
          intervalInSeconds: 30
          enabledState: 'Enabled'
          healthProbeMethod: 'HEAD'
        }
      }
    ]
    backendPools: [
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/BackendPools/tku-paoh-${environment}-frontdoorbackendpool'
        name: 'tku-paoh-${environment}-frontdoorbackendpool'
        properties: {
          backends: [
            {
              address: 'palveluohjain-${environment}-aks.westeurope.cloudapp.azure.com'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              backendHostHeader: 'palveluohjain-${environment}-aks.westeurope.cloudapp.azure.com'
              enabledState: 'Enabled'
            }
          ]
          loadBalancingSettings: {
            id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/LoadBalancingSettings/loadBalancingSettings-1634724196655'
          }
          healthProbeSettings: {
            id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/HealthProbeSettings/healthProbeSettings-1634724196655'
          }
        }
      }
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/BackendPools/tku-paoh-${environment}-frontdoorbackendpool-wa'
        name: 'tku-paoh-${environment}-frontdoorbackendpool-wa'
        properties: {
          backends: [
            {
              address: 'white-hill-019f2f703.azurestaticapps.net'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              backendHostHeader: 'white-hill-019f2f703.azurestaticapps.net'
              enabledState: 'Enabled'
            }
          ]
          loadBalancingSettings: {
            id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/LoadBalancingSettings/loadBalancingSettings-1635158028884'
          }
          healthProbeSettings: {
            id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/HealthProbeSettings/healthProbeSettings-1635158028884'
          }
        }
      }
    ]
    frontendEndpoints: [
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/FrontendEndpoints/${frontdoors_palveluohjain_env_frontdoor_name}-azurefd-net'
        name: '${frontdoors_palveluohjain_env_frontdoor_name}-azurefd-net'
        properties: {
          hostName: '${frontdoors_palveluohjain_env_frontdoor_name}.azurefd.net'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 0
          webApplicationFirewallPolicyLink: {
            id: frontdoorwebapplicationfirewallpolicies_tkupaohenvwafpolicy_name_resource.id
          }
        }
      }
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/FrontendEndpoints/www-palveluohjaaja-fi'
        name: 'www-palveluohjaaja-fi'
        properties: {
          hostName: 'www.palveluohjaaja.fi'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 0
          webApplicationFirewallPolicyLink: {
            id: frontdoorwebapplicationfirewallpolicies_tkupaohenvwafpolicy_name_resource.id
          }
        }
      }
      {
        id: '${resourceId('Microsoft.Network/frontdoors', frontdoors_palveluohjain_env_frontdoor_name)}/FrontendEndpoints/botfront-palveluohjaaja-fi'
        name: 'botfront-palveluohjaaja-fi'
        properties: {
          hostName: 'botfront.palveluohjaaja.fi'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 0
        }
      }
    ]
    backendPoolsSettings: {
      enforceCertificateNameCheck: 'Enabled'
      sendRecvTimeoutSeconds: 30
    }
    enabledState: 'Enabled'
    friendlyName: frontdoors_palveluohjain_env_frontdoor_name
  }
}



