# Deployment Pipelines — Implementation Results ✅

Created **24 files** across all three deployment methods for Lyle's Handouts Website.

## Bicep Infrastructure (`infra/bicep/`)

| File | Purpose |
|------|---------|
| `main.bicep` | Orchestrator: Storage + Static Web App + RBAC |
| `resourcenames.bicep` | Consistent Azure naming conventions |
| `main.bicepparam` / `main.parameters.json` | Parameter files with CI/CD token placeholders |
| `modules/storage/storageaccount.bicep` | Storage Account + `handouts` blob container + CORS |
| `modules/staticwebapp/staticwebapp.bicep` | SWA with managed identity + `azd-service-name` tag |
| `modules/iam/roleassignments.bicep` | Storage Blob Data Reader role for SWA identity |

## GitHub Actions (`.github/workflows/`)

- **`1-deploy-bicep.yml`** — Infrastructure only (manual trigger)
- **`2-build-deploy-staticwebapp.yml`** — Full: infra → build → deploy (manual trigger)
- **`3-upload-handouts.yml`** — Sync handouts/ to Azure Blob Storage
- 3 reusable templates: `template-load-config`, `template-bicep-deploy`, `template-staticwebapp-build-deploy`
- 2 composite actions: `load-project-config`, `login-action` (OIDC + secret fallback)

## Azure DevOps (`.azure/pipelines/`)

- **`1-deploy-bicep.yml`** / **`2-build-deploy-staticwebapp.yml`** / **`3-upload-handouts.yml`**
- Reusable steps in `steps/` + shared variables in `vars/`
- ⚠️ Replace `'your-service-connection'` placeholder with your ADO service connection name

## Azure Developer CLI

- **`azure.yaml`** — `azd up` provisions infrastructure + deploys website

## Documentation

- `infra/bicep/CreateGitHubSecrets.md` — Simplified secrets/variables guide
- `infra/bicep/workflows-readme.md` — Workflow documentation
- `docs/agent-memory/deployment_pipelines_plan.md` — Full plan for future agent reference
