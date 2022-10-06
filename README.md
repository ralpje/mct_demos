# MCT Demos
This is a repository containing Bicep-files for quickly deploying demo-environments used in training scenarios.

The following demos can be provisioned using this templates.

### vNet-Peering
This template will deploy two separate /24 vNets, each with 4 /26 subnets. 
Two VM's are placed in one vNet, one VM is placed in the second vNet. You can demonstrate there is an active connection between the VM's in the first vNet, but not to the second vNet. 
After manually creating a peering between the two vNets, there will be a connection. 

To deploy this demo using Powershell:
```Powershell
New-AZResourceGroupDeployment -Templatefile demo_vNetPeering.bicep -ResourceGroup ResourceGroupName
````

