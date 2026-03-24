// ============================================================================
// Resource Naming Module
// Generates consistent, Azure-compliant resource names for the Handouts app.
// ============================================================================

@description('The application name used as a base for all resource names.')
param appName string

@description('The environment code (e.g., dev, tst, prd).')
param environmentCode string

@description('The instance number for multi-instance deployments.')
param instanceNumber string = '1'

// ---------------------------------------------------------------------------
var sanitizedAppName = toLower(replace(appName, '-', ''))
var sanitizedEnv = toLower(environmentCode)

// Storage account names: lowercase, no hyphens, max 24 characters
var storageAccountNameRaw = 'st${sanitizedAppName}${sanitizedEnv}${instanceNumber}'

// ---------------------------------------------------------------------------
@description('The generated Storage Account name (lowercase, no hyphens, max 24 chars).')
output storageAccountName string = length(storageAccountNameRaw) > 24 ? substring(storageAccountNameRaw, 0, 24) : storageAccountNameRaw

@description('The generated Static Web App name.')
output staticWebAppName string = 'swa-${toLower(appName)}-${sanitizedEnv}-${instanceNumber}'

@description('The generated Resource Group name.')
output resourceGroupName string = 'rg-${toLower(appName)}-${sanitizedEnv}'
