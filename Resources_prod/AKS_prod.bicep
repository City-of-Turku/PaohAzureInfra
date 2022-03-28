param subscriptionId string = '313543fe-ab85-4ba0-8f49-6f0845adcbcf'
param intraResourceGroupName string = 'tku-palveluohjain-intra'
param resourceGroupName string = 'tku-palveluohjain-testi'
param environment string = 'iacdev'
param envPrefix1 string = 'tku-paoh-${environment}'
param envPrefix2 string = 'tkupaoh${environment}'

param managedClusters_tku_paoh_env_aks_name string = '${envPrefix1}-aks'
param publicIPAddresses_tku_paoh_env_aks_ip_name string = '${envPrefix1}-aks-ip'
param virtualNetworks_tku_paoh_env_virtualnetwork_name string = '${envPrefix1}-virtualnetwork'

resource virtualNetworks_tku_paoh_env_virtualnetwork_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: virtualNetworks_tku_paoh_env_virtualnetwork_name
}

resource virtualNetworks_tku_paoh_env_virtualnetwork_name_default 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  name: 'default'
  parent: virtualNetworks_tku_paoh_env_virtualnetwork_name_resource
}


resource publicIPAddresses_tku_paoh_env_aks_ip_name_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_tku_paoh_env_aks_ip_name
  location: 'westeurope'
  tags: {
    'kubernetes-dns-label-service': 'ingress-basic/nginx-ingress-ingress-nginx-controller'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      domainNameLabel: 'palveluohjain-${environment}-aks'
      fqdn: 'palveluohjain-${environment}-aks.westeurope.cloudapp.azure.com'
    }
    ipTags: []
  }
}


resource managedClusters_tku_paoh_env_aks_name_resource 'Microsoft.ContainerService/managedClusters@2021-08-01' = {
  name: managedClusters_tku_paoh_env_aks_name
  location: 'westeurope'
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: '1.20.9'
    dnsPrefix: '${managedClusters_tku_paoh_env_aks_name}-dns'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_E2as_v4'
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        kubeletDiskType: 'OS'
        vnetSubnetID: virtualNetworks_tku_paoh_env_virtualnetwork_name_default.id
        maxPods: 60
        type: 'VirtualMachineScaleSets'
        availabilityZones: [
          '1'
          '2'
          '3'
        ]
        maxCount: 3
        minCount: 2
        enableAutoScaling: true
        orchestratorVersion: '1.20.9'
        mode: 'System'
        osType: 'Linux'
        osSKU: 'Ubuntu'
        enableFIPS: false
      }
    ]
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    addonProfiles: {
      azurepolicy: {
        enabled: false
      }
      httpApplicationRouting: {
        enabled: false
      }
    }
    nodeResourceGroup: 'MC_${resourceGroupName}_${managedClusters_tku_paoh_env_aks_name}_westeurope'
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
      loadBalancerProfile: {
        managedOutboundIPs: {
          count: 1
        }
      }
      serviceCidr: '10.1.0.0/16'
      dnsServiceIP: '10.1.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
      outboundType: 'loadBalancer'
    }
    aadProfile: {
      managed: true
      adminGroupObjectIDs: [
        '201a6697-0dae-46a6-a6f2-7fa3c88d3e26'
      ]
      tenantID: '6c5e2c8a-d3f0-4a0b-9658-42502c73e17b'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: false
    }
    autoScalerProfile: {
      'balance-similar-node-groups': 'false'
      expander: 'random'
      'max-empty-bulk-delete': '10'
      'max-graceful-termination-sec': '600'
      'max-node-provision-time': '15m'
      'max-total-unready-percentage': '45'
      'new-pod-scale-up-delay': '0s'
      'ok-total-unready-count': '3'
      'scale-down-delay-after-add': '10m'
      'scale-down-delay-after-delete': '10s'
      'scale-down-delay-after-failure': '3m'
      'scale-down-unneeded-time': '10m'
      'scale-down-unready-time': '20m'
      'scale-down-utilization-threshold': '0.5'
      'scan-interval': '10s'
      'skip-nodes-with-local-storage': 'false'
      'skip-nodes-with-system-pods': 'true'
    }
    autoUpgradeProfile: {
      upgradeChannel: 'stable'
    }
    publicNetworkAccess: 'Enabled'
  }
}


resource managedClusters_tku_paoh_env_aks_name_default 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2021-08-01' = {
  parent: managedClusters_tku_paoh_env_aks_name_resource
  name: 'default'
  properties: {
    timeInWeek: [
      {
        day: 'Saturday'
        hourSlots: [
          4
        ]
      }
    ]
  }
}


resource managedClusters_tku_paoh_env_aks_name_scalepool 'Microsoft.ContainerService/managedClusters/agentPools@2021-08-01' = {
  parent: managedClusters_tku_paoh_env_aks_name_resource
  name: 'scalepool'
  properties: {
    count: 2
    vmSize: 'Standard_E2as_v4'
    osDiskSizeGB: 128
    osDiskType: 'Managed'
    kubeletDiskType: 'OS'
    vnetSubnetID: virtualNetworks_tku_paoh_env_virtualnetwork_name_default.id
    maxPods: 60
    type: 'VirtualMachineScaleSets'
    availabilityZones: [
      '1'
      '2'
      '3'
    ]
    maxCount: 3
    minCount: 2
    enableAutoScaling: true
    orchestratorVersion: '1.20.9'
    mode: 'System'
    osType: 'Linux'
    osSKU: 'Ubuntu'
    enableFIPS: false
  }
}


