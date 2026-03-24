# Deployment Pipelines Plan — Lyle's Handouts Website

## Problem Statement

The Handouts Website is a React + TypeScript + Vite static site (`src/website/`) that needs deployment pipelines to provision Azure infrastructure and deploy the app. Per `readme.md`, the infrastructure consists of:

- **Azure Storage Account** — hosts handout files (blob storage)
- **Azure Static Web App** — hosts the React website
- **Permissions** — SWA must be able to read from the Storage Account

Pipelines must support three deployment methods: **GitHub Actions**, **Azure DevOps Pipelines**, and **Azure Developer CLI (`azd up`)**. All pipelines are **manually triggered only**.

## Current State

| Component | Status |
|---|---|
| React/Vite app (`src/website/`) | ✅ Exists — builds to `dist/` |
| Bicep infrastructure (`infra/bicep/`) | ❌ No `.bicep` files — only reference materials from dadabase.demo |
| GitHub Actions (`.github/workflows/`) | ❌ Empty — no workflow files |
| Azure DevOps (`.azure/pipelines/`) | ❌ Empty — no pipeline files |
| AZD config (`azure.yaml`) | ❌ Does not exist |
| Composite actions (`infra/bicep/actions/`) | ⚠️ Exist but in wrong location — must be at `.github/actions/` |
| Project config (`infra/bicep/config/projects.yml`) | ⚠️ Exists but contains dadabase.demo config — needs rewrite |

## Reference Architecture

Following the **dadabase.demo** golden code patterns:
- Numbered main workflows (e.g., `1-deploy-bicep.yml`, `2-build-deploy-*.yml`)
- Reusable template workflows (`template-*.yml`) called via `workflow_call`
- Composite actions for config loading and Azure login
- OIDC federated credentials (no stored client secrets)
- Token replacement in Bicep parameter files
- `workflow_dispatch` for manual triggers with input options
- Modular Bicep with a `main.bicep` orchestrator and per-resource modules

---

## Todos

### 1. Update Project Configuration
**ID:** `update-config`

Update `infra/bicep/config/projects.yml` to reflect this project (not dadabase.demo):

```yaml
projects:
  website:
    shortName: 'web'
    rootDirectory: 'src/website'
    projectName: 'lyles-handouts-website'
    testDirectory: ''
    testProjectName: ''
```

### 2. Create Bicep Infrastructure Files
**ID:** `create-bicep`

Create the Azure infrastructure-as-code files in `infra/bicep/`:

#### 2a. `infra/bicep/main.bicep` — Main orchestrator
- Accept parameters: `appName`, `location`, `environmentCode`, `instanceNumber`
- Call module for Storage Account
- Call module for Static Web App
- Set up role assignments (Storage Blob Data Reader for SWA managed identity)
- Output resource names and endpoints

#### 2b. `infra/bicep/main.bicepparam` — Parameter file (modern Bicep v0.18+ syntax)
- Use token replacement placeholders (e.g., `#{APP_NAME}#`) for CI/CD variable injection
- Reference GitHub/ADO variables for `appName`, `location`, `resourceGroupPrefix`, `instanceNumber`

#### 2c. `infra/bicep/main.parameters.json` — Legacy JSON parameter file (for CLI/azd fallback)
- Same parameters as `main.bicepparam` but in JSON format

#### 2d. `infra/bicep/resourcenames.bicep` — Naming conventions module
- Generate consistent, globally-unique resource names from `appName` + `environmentCode` + `instanceNumber`
- Follow Azure naming conventions (lowercase, no special chars for storage)
- Output: `storageAccountName`, `staticWebAppName`, `resourceGroupName`

#### 2e. `infra/bicep/modules/storage/storageaccount.bicep` — Storage Account module
- Create Storage Account (Standard_LRS, StorageV2)
- Enable blob public access or configure SAS policy for handout downloads
- Create a `handouts` blob container
- Enable CORS for the Static Web App origin
- Output: storage account name, blob endpoint, connection info

#### 2f. `infra/bicep/modules/staticwebapp/staticwebapp.bicep` — Static Web App module
- Create Azure Static Web App (Free or Standard tier)
- Configure build settings (app location: `/`, output: `dist`)
- Enable managed identity (system-assigned) for Storage access
- Output: SWA name, default hostname, deployment token

#### 2g. Role Assignment
- In `main.bicep`, assign the **Storage Blob Data Reader** role to the SWA's managed identity on the Storage Account
- This enables the website to read handout files from blob storage

### 3. Move Composite Actions to Correct Location
**ID:** `move-actions`

GitHub Actions composite actions must live under `.github/actions/`:

- Copy `infra/bicep/actions/load-project-config/action.yml` → `.github/actions/load-project-config/action.yml`
  - Update the config file path from `.github/config/projects.yml` to `.github/config/projects.yml` (or adjust to actual location)
- Copy `infra/bicep/actions/login-action/action.yml` → `.github/actions/login-action/action.yml`
- Copy `infra/bicep/config/projects.yml` → `.github/config/projects.yml`
- Simplify the `load-project-config` action to only output `website` project fields (remove dadabase-specific projects)

### 4. Create GitHub Actions Workflows
**ID:** `create-github-actions`  
**Depends on:** `update-config`, `create-bicep`, `move-actions`

#### 4a. `.github/workflows/template-load-config.yml` — Configuration loader template
- Reusable workflow (`workflow_call`)
- Uses `.github/actions/load-project-config` composite action
- Outputs project metadata for downstream jobs

#### 4b. `.github/workflows/template-bicep-deploy.yml` — Infrastructure deployment template
- Reusable workflow (`workflow_call`)
- Inputs: `envCode`, `templatePath`, `templateFile`, `parameterFile`, `resourceGroupName`, `location`, `deploymentMode` (create/validate/whatIf)
- Steps:
  1. Checkout code
  2. Azure Login (OIDC via `.github/actions/login-action`)
  3. Token replacement in parameter file (`qetza/replacetokens-action@v1`)
  4. Create resource group if needed (`az group create`)
  5. Run What-If analysis (if mode=whatIf)
  6. Deploy Bicep (`azure/bicep-deploy@v2` or `az deployment group create`)
- Secrets: inherit (AZURE_SUBSCRIPTION_ID, AZURE_TENANT_ID, CICD_CLIENT_ID)

#### 4c. `.github/workflows/template-staticwebapp-build-deploy.yml` — SWA build & deploy template
- Reusable workflow (`workflow_call`)
- Inputs: `rootDirectory`, `envCode`
- Steps:
  1. Checkout code
  2. Setup Node.js (v20)
  3. `npm ci` in `src/website/`
  4. `npm run build` in `src/website/`
  5. Azure Login
  6. Get SWA deployment token from Azure (`az staticwebapp secrets list`)
  7. Deploy using `Azure/static-web-apps-deploy@v1` with `app_location: src/website` and `output_location: dist`

#### 4d. `.github/workflows/1-deploy-bicep.yml` — Main: Deploy infrastructure only
- Trigger: `workflow_dispatch` with inputs:
  - `deployEnvironment` (type: environment, required)
  - `deploymentMode` (choice: create/validate/whatIf, default: create)
- Permissions: id-token write, contents read
- Jobs:
  1. `load-config` → calls `template-load-config.yml`
  2. `deploy-infra` → calls `template-bicep-deploy.yml`

#### 4e. `.github/workflows/2-build-deploy-staticwebapp.yml` — Main: Build & deploy everything
- Trigger: `workflow_dispatch` with inputs:
  - `deployEnvironment` (type: environment, required)
  - `deploymentMode` (choice: create/validate/whatIf, default: create)
- Permissions: id-token write, contents read
- Jobs:
  1. `load-config` → calls `template-load-config.yml`
  2. `deploy-infra` → calls `template-bicep-deploy.yml` (needs: load-config)
  3. `build-deploy-web` → calls `template-staticwebapp-build-deploy.yml` (needs: deploy-infra)

#### 4f. `.github/workflows/3-scan-code.yml` (Optional) — Security scanning
- Trigger: `workflow_dispatch` + schedule (weekly)
- Run GitHub Advanced Security / Microsoft DevSecOps scan on the codebase

### 5. Create Azure DevOps Pipelines
**ID:** `create-ado-pipelines`  
**Depends on:** `update-config`, `create-bicep`

#### 5a. `.azure/pipelines/vars/variables.yml` — Variable definitions
- Define pipeline-level variables: `APP_NAME`, `RESOURCE_GROUP_PREFIX`, `RESOURCE_GROUP_LOCATION`, `INSTANCE_NUMBER`
- Reference ADO variable group for secrets (`AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`, `CICD_CLIENT_ID`)

#### 5b. `.azure/pipelines/steps/bicep-deploy.yml` — Reusable step template
- Parameters: `templateFile`, `parameterFile`, `resourceGroupName`, `location`, `azureSubscription` (service connection name)
- Steps: Token replacement → Create RG → Deploy Bicep

#### 5c. `.azure/pipelines/steps/staticwebapp-build-deploy.yml` — Reusable step template
- Parameters: `rootDirectory`, `azureSubscription`
- Steps: Setup Node → npm ci → npm build → Get SWA token → Deploy SWA

#### 5d. `.azure/pipelines/1-deploy-bicep.yml` — Main: Infrastructure only
- Trigger: none (manual only)
- Parameters: `deployEnvironment`, `deploymentMode`
- Stages: Validate → Deploy (with environment approval gates)

#### 5e. `.azure/pipelines/2-build-deploy-staticwebapp.yml` — Main: Full deploy
- Trigger: none (manual only)
- Parameters: `deployEnvironment`
- Stages: Deploy Infra → Build & Deploy Website

### 6. Create Azure Developer CLI (azd) Configuration
**ID:** `create-azd`  
**Depends on:** `create-bicep`

#### 6a. `azure.yaml` — Root AZD configuration
```yaml
name: lyles-handouts-website
infra:
  provider: bicep
  path: infra/bicep
  module: main
services:
  website:
    project: ./src/website
    language: js
    host: staticwebapp
    dist: dist
```

#### 6b. `.azure/readme.md` — AZD setup and usage guide
- Document `azd init`, `azd up`, `azd provision`, `azd deploy`, `azd down`
- Document required environment variables
- Document how to switch environments

### 7. Update Documentation
**ID:** `update-docs`  
**Depends on:** `create-github-actions`, `create-ado-pipelines`, `create-azd`

#### 7a. Update `infra/bicep/CreateGitHubSecrets.md`
- Simplify to only include secrets/variables needed for this project:
  - `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`, `CICD_CLIENT_ID`
  - `APP_NAME`, `RESOURCE_GROUP_LOCATION`, `RESOURCE_GROUP_PREFIX`, `INSTANCE_NUMBER`
- Remove all dadabase.demo-specific secrets (SQL, OpenAI, Login, etc.)

#### 7b. Update `infra/bicep/workflows-readme.md`
- Document the handouts-specific workflows (1-deploy-bicep, 2-build-deploy-staticwebapp)
- Document required secrets and setup sequence
- Document the Azure DevOps pipeline equivalents

#### 7c. Create `docs/agent-memory/deployment_pipelines_plan.md`
- Store a copy of this plan for future agent reference

### 8. Upload Handout Files Pipeline (Optional Enhancement)
**ID:** `create-upload-pipeline`  
**Depends on:** `create-github-actions`, `create-ado-pipelines`

Create an optional workflow/pipeline to sync the `handouts/` folder to the Azure Storage blob container:

- GitHub Actions: `.github/workflows/3-upload-handouts.yml`
  - Manual trigger
  - Uses `az storage blob upload-batch` to sync local `handouts/` folder to the blob container
- Azure DevOps: `.azure/pipelines/3-upload-handouts.yml` (equivalent)

---

## File Summary

| # | File Path | Action | Description |
|---|-----------|--------|-------------|
| 1 | `.github/config/projects.yml` | Create | Project config (adapted from existing) |
| 2 | `.github/actions/load-project-config/action.yml` | Create | Composite action (adapted from existing) |
| 3 | `.github/actions/login-action/action.yml` | Create | Composite action (adapted from existing) |
| 4 | `infra/bicep/main.bicep` | Create | Main Bicep orchestrator |
| 5 | `infra/bicep/main.bicepparam` | Create | Modern parameter file |
| 6 | `infra/bicep/main.parameters.json` | Create | Legacy JSON parameters |
| 7 | `infra/bicep/resourcenames.bicep` | Create | Naming conventions module |
| 8 | `infra/bicep/modules/storage/storageaccount.bicep` | Create | Storage Account module |
| 9 | `infra/bicep/modules/staticwebapp/staticwebapp.bicep` | Create | Static Web App module |
| 10 | `.github/workflows/template-load-config.yml` | Create | Reusable config loader |
| 11 | `.github/workflows/template-bicep-deploy.yml` | Create | Reusable infra deploy |
| 12 | `.github/workflows/template-staticwebapp-build-deploy.yml` | Create | Reusable SWA build+deploy |
| 13 | `.github/workflows/1-deploy-bicep.yml` | Create | Main: Infra only |
| 14 | `.github/workflows/2-build-deploy-staticwebapp.yml` | Create | Main: Full deploy |
| 15 | `.azure/pipelines/vars/variables.yml` | Create | ADO variable definitions |
| 16 | `.azure/pipelines/steps/bicep-deploy.yml` | Create | ADO reusable step |
| 17 | `.azure/pipelines/steps/staticwebapp-deploy.yml` | Create | ADO reusable step |
| 18 | `.azure/pipelines/1-deploy-bicep.yml` | Create | ADO: Infra only |
| 19 | `.azure/pipelines/2-build-deploy-staticwebapp.yml` | Create | ADO: Full deploy |
| 20 | `azure.yaml` | Create | AZD configuration |
| 21 | `.azure/readme.md` | Create/Update | AZD setup guide |
| 22 | `infra/bicep/CreateGitHubSecrets.md` | Update | Simplify for this project |
| 23 | `infra/bicep/workflows-readme.md` | Update | Document new workflows |
| 24 | `docs/agent-memory/deployment_pipelines_plan.md` | Create | This plan (for agent memory) |

---

## Key Design Decisions

1. **OIDC Authentication** — Use federated credentials (no client secrets stored in CI/CD). Requires setting up a service principal with federated credentials in Entra ID.
2. **Static Web App** — Free tier is sufficient for a handouts site. The SWA handles SSL, CDN, and custom domains automatically.
3. **Storage Account** — Standard_LRS is sufficient. Handouts served via blob public access or SAS tokens.
4. **Manual triggers only** — All workflows use `workflow_dispatch` per requirements. No automatic triggers on push/PR.
5. **Token replacement** — Use `qetza/replacetokens-action` in GitHub Actions (and equivalent in ADO) to inject environment-specific values into Bicep parameter files at deployment time.
6. **Modular Bicep** — Separate modules for each resource type, orchestrated by `main.bicep`, following dadabase.demo patterns.

## Notes

- The existing files in `infra/bicep/actions/`, `infra/bicep/config/`, and `infra/bicep/scripts/` appear to be reference materials copied from dadabase.demo. They will be adapted and placed in their correct locations (`.github/actions/`, `.github/config/`).
- The `handouts/` folder is currently empty. The upload pipeline (Todo 8) will handle syncing handout files to Azure Storage.
- Azure Static Web Apps can be configured to use an API backend, but for this simple use case, the website will call Azure Blob Storage directly via JavaScript (using the blob endpoint URL or SAS token configured in the SWA app settings).
