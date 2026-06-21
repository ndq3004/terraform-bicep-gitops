# Bicep main template
# This is the entry point for all Azure resources

param location string = 'westeurope'
param environment string = 'dev'
param projectName string = 'aks-gitops'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${projectName}-${environment}-${location}'
  location: location
}

output resourceGroupName string = rg.name
output resourceGroupId string = rg.id
