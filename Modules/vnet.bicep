param vnetName string
param location string
param vNetPrefix string

// Variables are used for creating the different subnet prefixes
var addressSpacePrefix = split(vNetPrefix,'.')
var addressSpace = '${addressSpacePrefix[0]}.${addressSpacePrefix[1]}.${addressSpacePrefix[2]}'

// Create an NSG allowing RDP in for all destinations. This will be attached to all subnets
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: '${vnetName}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP-In'
        properties: {
          description: 'Allow RDP Traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

// Set up the vNet
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName

  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetPrefix
      ]
    }
    subnets: [
      {
        name: '${vnetName}-1'
        properties: {
          addressPrefix: '${addressSpace}.0/26'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
      {
        name: '${vnetName}-2'
        properties: {
          addressPrefix: '${addressSpace}.64/26'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
      {
        name: '${vnetName}-3'
        properties: {
          addressPrefix: '${addressSpace}.128/26'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
      {
        name: '${vnetName}-4'
        properties: {
          addressPrefix: '${addressSpace}.192/26'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

output subnet1 string = resourceId('Microsoft.Network/VirtualNetworks/subnets', vnetName, '${vnetName}-1')
output subnet2 string = resourceId('Microsoft.Network/VirtualNetworks/subnets', vnetName, '${vnetName}-2')
output subnet3 string = resourceId('Microsoft.Network/VirtualNetworks/subnets', vnetName, '${vnetName}-3')
output subnet4 string = resourceId('Microsoft.Network/VirtualNetworks/subnets', vnetName, '${vnetName}-4')
