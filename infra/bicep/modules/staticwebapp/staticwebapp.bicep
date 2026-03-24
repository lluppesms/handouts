// ============================================================================
// Static Web App Module
// Creates an Azure Static Web App with system-assigned managed identity
// for hosting the React + Vite handouts website.
// ============================================================================

@description('The name of the Static Web App.')
param staticWebAppName string

@description('The Azure region for the Static Web App.')
param location string

@description('Tags to apply to the Static Web App.')
param tags object

@description('The SKU for the Static Web App (Free or Standard).')
@allowed(['Free', 'Standard'])
param sku string = 'Free'

@description('Blob storage endpoint for the handouts container.')
param storageBlobEndpoint string = ''

@description('Name of the blob container holding handouts.')
param storageContainerName string = 'handouts'

// Build app settings when storage endpoint is provided
var appSettings = !empty(storageBlobEndpoint) ? {
  STORAGE_BLOB_ENDPOINT: storageBlobEndpoint
  STORAGE_CONTAINER_NAME: storageContainerName
} : {}

// Static Web App with system-assigned managed identity
resource staticWebApp 'Microsoft.Web/staticSites@2023-12-01' = {
  name: staticWebAppName
  location: location
  tags: union(tags, { 'azd-service-name': 'website' })
  sku: {
    name: sku
    tier: sku
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    buildProperties: {
      skipGithubActionWorkflowGeneration: true
    }
  }
}

// Configure app settings if storage endpoint is provided
resource staticWebAppSettings 'Microsoft.Web/staticSites/config@2023-12-01' = if (!empty(storageBlobEndpoint)) {
  parent: staticWebApp
  name: 'appsettings'
  properties: appSettings
}

@description('The name of the Static Web App.')
output staticWebAppName string = staticWebApp.name

@description('The resource ID of the Static Web App.')
output staticWebAppId string = staticWebApp.id

@description('The default hostname of the Static Web App.')
output defaultHostname string = staticWebApp.properties.defaultHostname

@description('The URL of the Static Web App.')
output url string = 'https://${staticWebApp.properties.defaultHostname}'

@description('The principal ID of the system-assigned managed identity.')
output principalId string = staticWebApp.identity.principalId
