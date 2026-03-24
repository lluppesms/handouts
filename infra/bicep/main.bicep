// ============================================================================
// Main Orchestrator - Lyle's Handouts Website Infrastructure
// Deploys Storage Account, Static Web App, and RBAC role assignment.
// ============================================================================
// To deploy manually:
//   az login
//   az account set --subscription <subscriptionId>
//   az deployment group create -n "manual-deploy" --resource-group rg-handouts \
//     --template-file 'main.bicep' --parameters appName=lyle-handouts environmentCode=dev
// ============================================================================

targetScope = 'resourceGroup'

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------

@description('The application name used for resource naming.')
param appName string

@description('The Azure region for all resources.')
param location string = resourceGroup().location

@description('The environment code (e.g., dev, tst, prd).')
param environmentCode string = 'dev'

@description('The instance number for multi-instance deployments.')
param instanceNumber string = '1'

@description('Tags to apply to all resources.')
param tags object = {
  app: appName
  env: environmentCode
}

// ---------------------------------------------------------------------------
// Resource Naming
// ---------------------------------------------------------------------------

module names 'resourcenames.bicep' = {
  name: 'resourcenames'
  params: {
    appName: appName
    environmentCode: environmentCode
    instanceNumber: instanceNumber
  }
}

// ---------------------------------------------------------------------------
// Storage Account (blob storage for handout files)
// ---------------------------------------------------------------------------

module storage 'modules/storage/storageaccount.bicep' = {
  name: 'storage'
  params: {
    storageAccountName: names.outputs.storageAccountName
    location: location
    tags: tags
  }
}

// ---------------------------------------------------------------------------
// Static Web App (React + Vite website)
// ---------------------------------------------------------------------------

module staticWebApp 'modules/staticwebapp/staticwebapp.bicep' = {
  name: 'staticwebapp'
  params: {
    staticWebAppName: names.outputs.staticWebAppName
    location: location
    tags: tags
    storageBlobEndpoint: storage.outputs.blobEndpoint
  }
}

// ---------------------------------------------------------------------------
// Role Assignment: SWA managed identity → Storage Blob Data Reader
// Deployed via a sub-module so that runtime outputs (principalId) can be
// used without BCP120 restrictions on the parent scope.
// ---------------------------------------------------------------------------

module roleAssignment 'modules/iam/roleassignments.bicep' = {
  name: 'roleAssignment'
  params: {
    storageAccountName: storage.outputs.storageAccountName
    identityPrincipalId: staticWebApp.outputs.principalId
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

@description('The name of the deployed Storage Account.')
output storageAccountName string = storage.outputs.storageAccountName

@description('The name of the deployed Static Web App.')
output staticWebAppName string = staticWebApp.outputs.staticWebAppName

@description('The default hostname of the Static Web App.')
output staticWebAppHostname string = staticWebApp.outputs.defaultHostname

@description('The primary blob endpoint URL.')
output storageBlobEndpoint string = storage.outputs.blobEndpoint
