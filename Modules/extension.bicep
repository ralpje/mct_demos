param fileurl string = 'https://raw.githubusercontent.com/ralpje/DemoSite/main/scipt.ps1'
param vmname string
param location string = 'westeurope'
resource customscriptextension 'Microsoft.Compute/virtualMachines/extensions@2022-03-01' = {
  name: '${vmname}/TestScript'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        fileurl
      ]
      commandToExecute: 'powershell -ExecutionPolicy Bypass -File script.ps1'
    }
  }
}
