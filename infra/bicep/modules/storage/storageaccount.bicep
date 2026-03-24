// ============================================================================
// Storage Account Module
// Creates an Azure Storage Account with a blob container for handout files
// and configures CORS for browser-based access.
// ============================================================================

@description('The name of the Storage Account.')
param storageAccountName string

@description('The Azure region for the Storage Account.')
param location string

@description('Tags to apply to the Storage Account.')
param tags object

@description('Whether to allow public access to blobs.')
param allowBlobPublicAccess bool = true

// ---------------------------------------------------------------------------
// Storage Account
// ---------------------------------------------------------------------------
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  tags: tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: allowBlobPublicAccess
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
  }
}

// ---------------------------------------------------------------------------
// Blob Services with CORS configuration
// ---------------------------------------------------------------------------
resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    cors: {
      corsRules: [
        {
          allowedOrigins: ['*']
          allowedMethods: ['GET', 'HEAD']
          allowedHeaders: ['*']
          exposedHeaders: ['*']
          maxAgeInSeconds: 3600
        }
      ]
    }
  }
}

// ---------------------------------------------------------------------------
// Blob container for handout files (public read access for downloads)
// ---------------------------------------------------------------------------
resource handoutsContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: blobServices
  name: 'handouts'
  properties: {
    publicAccess: 'Blob'
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------
@description('The name of the Storage Account.')
output storageAccountName string = storageAccount.name

@description('The resource ID of the Storage Account.')
output storageAccountId string = storageAccount.id

@description('The primary blob endpoint URL.')
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob

@description('The primary access key for the Storage Account.')
output primaryKey string = storageAccount.listKeys().keys[0].value
