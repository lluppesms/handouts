// ----------------------------------------------------------------------------------------------------
// This BICEP file is the main entry point for the azd command
// ----------------------------------------------------------------------------------------------------
// Deploy with: azd up
// ----------------------------------------------------------------------------------------------------
param name string
param location string
param runDateTime string = utcNow()

// --------------------------------------------------------------------------------
targetScope = 'subscription'

// --------------------------------------------------------------------------------
var tags = {
    Application: name
    LastDeployed: runDateTime
    'azd-env-name': name
}
var deploymentSuffix = '-${runDateTime}'

// --------------------------------------------------------------------------------
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
    name: 'rg-${name}'
    location: location
    tags: tags
}

module resources './bicep/main.bicep' = {
    name: 'resources${deploymentSuffix}'
    scope: resourceGroup
    params: {
        location: location
        appName: name
        environmentCode: 'azd'
    }
}

// --------------------------------------------------------------------------------
output STORAGE_ACCOUNT_NAME string = resources.outputs.storageAccountName
output STORAGE_BLOB_ENDPOINT string = resources.outputs.storageBlobEndpoint
output STATIC_WEB_APP_NAME string = resources.outputs.staticWebAppName
output STATIC_WEB_APP_URL string = resources.outputs.staticWebAppUrl
