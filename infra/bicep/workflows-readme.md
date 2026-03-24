# Deployment Workflows

## GitHub Actions Workflows

The GitHub workflows are located in `.github/workflows/`.

### Main Workflows

| Workflow | Description | Trigger |
|----------|-------------|---------|
| [1-deploy-bicep.yml](../../.github/workflows/1-deploy-bicep.yml) | Deploys Azure infrastructure (Storage Account + Static Web App) | Manual |
| [2-build-deploy-staticwebapp.yml](../../.github/workflows/2-build-deploy-staticwebapp.yml) | Deploys infrastructure, builds the React app, and deploys to Static Web App | Manual |

### Template Workflows (Reusable)

| Template | Description |
|----------|-------------|
| template-load-config.yml | Loads project configuration from `.github/config/projects.yml` |
| template-bicep-deploy.yml | Deploys Bicep templates with token replacement |
| template-staticwebapp-build-deploy.yml | Builds the Vite/React app and deploys to Azure Static Web App |

### Workflow Sequence

1. **First time**: Run `1-deploy-bicep.yml` to create Azure resources
2. **Subsequent deploys**: Run `2-build-deploy-staticwebapp.yml` to update infrastructure and deploy the website
3. **Upload handouts**: Run `3-upload-handouts.yml` to sync handout files to Azure Storage

---

## Azure DevOps Pipelines

The Azure DevOps pipelines are located in `.azure/pipelines/`.

| Pipeline | Description |
|----------|-------------|
| [1-deploy-bicep.yml](.azure/pipelines/1-deploy-bicep.yml) | Deploy infrastructure only |
| [2-build-deploy-staticwebapp.yml](.azure/pipelines/2-build-deploy-staticwebapp.yml) | Full build and deploy |

**Setup**: Create a variable group called `HandoutsWebsite` in Azure DevOps Library with the required variables. Replace `'your-service-connection'` in the pipeline files with your Azure service connection name.

---

## Azure Developer CLI (azd)

For quick deployments, use the Azure Developer CLI:

```bash
azd up        # Provision infrastructure + deploy website
azd provision # Infrastructure only
azd deploy    # Deploy website only
azd down      # Remove all resources
```

See [.azure/readme.md](../../.azure/readme.md) for detailed setup instructions.

---

## Prerequisites

1. Set up GitHub secrets and variables — see [CreateGitHubSecrets.md](./CreateGitHubSecrets.md)
2. Create a service principal with OIDC federated credentials
3. Grant the service principal Contributor access to your Azure subscription (or resource group)

---

[Home Page](../../readme.md)
