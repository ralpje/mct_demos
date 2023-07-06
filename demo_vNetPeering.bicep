// Use this template to deploy two vNets with corresponding subnets
// No peering between the vNets will be made
// You can use this template to demonstrate Azure Networking and the use of Peering

// Declare Parameters
param location string = resourceGroup().location
param userid string = 'DemoUser'

// Define keyvault
resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'keyvaultralph'
  scope: resourceGroup('33befcea-5e07-4e3b-a5aa-3735e3cc7d50', 'rg-keyvault')
}

// First vNet
module vNetA 'Modules/vnet.bicep' = {
  name: 'vNetA'
  params: { 
  vnetName: 'vNet-A'
  location: location
  vNetPrefix: '10.0.0.0/24' }
}

// Second vNet
module vNetB 'Modules/vnet.bicep' = {
  name: 'vNetB'
  params: {
  vnetName: 'vNet-B'
  location: location
  vNetPrefix: '192.168.0.0/24'
  }
}

// VM in vNet-A
module VM_A_1 'Modules/windowsVm.bicep' = {
  name: 'VM-A-1'
  params: {
    adminUsername: userid
    adminPassword: kv.getSecret(userid)
    location: location
    computerName: 'VM-A-1'
    vmSubnet: vNetA.outputs.subnet1
  }
  
}

// Extension for VM_A_!
module vmExtension 'Modules/extension.bicep' = {
  name: 'vmExtension'
  dependsOn: [VM_A_1]
  params: {
    vmname: 'VM-A-1'
    location: location
  }
}

// VM in vNet-A, secondary subnet
module VM_A_2 'Modules/windowsVm.bicep' ={
  name: 'VM-A-2'
  params: {
    adminUsername: userid
    adminPassword: kv.getSecret(userid)
    location: location
    computerName: 'VM-A-2'
    vmSubnet: vNetA.outputs.subnet2
  }
}

// VM in vNet-B
module VM_B 'Modules/windowsVm.bicep' = {
  name: 'VM-B-1'
  params: {
    adminUsername: userid
    adminPassword: kv.getSecret(userid)
    location: location
    computerName: 'VM-B-1'
    vmSubnet: vNetB.outputs.subnet1
  }
}
