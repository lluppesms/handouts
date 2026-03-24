# Azure Developer CLI (azd) Setup

## Prerequisites

- [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd) installed
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- An Azure subscription

## Getting Started

### 1. Initialize Environment

```bash
azd init
```

When prompted, provide:
- **Environment Name**: A unique name for your deployment (e.g., `handouts-dev`)

### 2. Configure Environment Variables

Set the required variables for your environment:

```bash
azd env set APP_NAME <your-app-name>
azd env set ENVIRONMENT_CODE dev
azd env set INSTANCE_NUMBER 1
```

### 3. Deploy Everything

Provision infrastructure and deploy the website in one command:

```bash
azd up
```

Or run each step separately:

```bash
azd provision    # Create Azure resources (Storage Account + Static Web App)
azd deploy       # Build and deploy the website
```

### 4. Clean Up

To remove all deployed resources:

```bash
azd down
```

## Environment Files

AZD stores environment-specific configuration in `.azure/<environment-name>/.env`. These files are gitignored and should not be committed.

## Useful Commands

| Command | Description |
|---------|-------------|
| `azd up` | Provision + deploy |
| `azd provision` | Create/update Azure resources |
| `azd deploy` | Build and deploy the app |
| `azd down` | Delete all Azure resources |
| `azd env list` | List all environments |
| `azd env set KEY VALUE` | Set an environment variable |
| `azd monitor` | Open Application Insights |
