// ============================================================================
// Role Assignment Module
// Assigns Storage Blob Data Reader to a given principal on a storage account.
// ============================================================================

@description('The name of the target Storage Account.')
param storageAccountName string

@description('The principal ID to grant access to (e.g., SWA managed identity).')
param identityPrincipalId string

@description('The type of principal being assigned the role.')
@allowed(['ServicePrincipal', 'User'])
param principalType string = 'ServicePrincipal'

// Storage Blob Data Reader built-in role
var storageBlobDataReaderRoleId = '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'

// ---------------------------------------------------------------------------

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: storageAccountName
}

resource blobDataReaderAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccount.id, identityPrincipalId, storageBlobDataReaderRoleId)
  scope: storageAccount
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataReaderRoleId)
    principalId: identityPrincipalId
    principalType: principalType
  }
}
