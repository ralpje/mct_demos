param location string 
param vmSize string = 'Standard_B2ms'
param computerName string
param adminUsername string
param windowsSku string = '2022-Datacenter'
param vmSubnet string
@secure()
param adminPassword string

// Get a public IP for the VM
resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: '${computerName}-pip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
  }
}


// Set up NIC using that PIP
resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${computerName}-nic01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: '${computerName}-nic01-config'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress.id
          }
          subnet: {
            id: vmSubnet
          }
        }
      }
    ]
  }
}

//Define the VM using the created NIC
resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: computerName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: computerName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: windowsSku
        version: 'latest'
      }
      osDisk: {
        name: '${computerName}-Disk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

