# Bicep Implementation Summary

## Files Created

| File | Purpose |
|------|---------|
| `infra/azd-main.bicep` | Subscription-scoped entry point for `azd up` |
| `infra/azd-main.parameters.json` | Parameters for AZD deployments |
| `infra/bicep/main.bicep` | Main orchestration — creates all resources |
| `infra/bicep/main.bicepparam` | Pipeline parameters (ADO / GitHub Actions) |
| `infra/bicep/main.parameters.json` | AZD resource-group-scoped parameters |
| `infra/bicep/resourcenames.bicep` | Generates consistent resource names |
| `infra/bicep/data/resourceAbbreviations.json` | Naming abbreviation map |
| `infra/bicep/data/roleDefinitions.json` | Azure RBAC role definition IDs |
| `infra/bicep/modules/storage/storageaccount.bicep` | Storage account + blob containers with CORS |
| `infra/bicep/modules/webapp/staticwebapp.bicep` | Azure Static Web App |
| `infra/bicep/modules/iam/roleassignments.bicep` | Storage RBAC role assignments |

## Architecture

- **Storage Account** — hosts handout files in a `handouts` container with public read access and CORS configured for the static web app
- **Static Web App** — hosts the React website with app settings pointing to the blob endpoint
- **RBAC module** — ready for Standard-tier SWA managed identity (commented out since Free tier doesn't support it)
- All files follow the dadabase.demo reference repo patterns (modular structure, data-driven naming, `commonTags`, etc.)

## Reference

- Based on patterns from [dadabase.demo](https://github.com/lluppesms/dadabase.demo/) `infra/Bicep` folder
- Infrastructure plan: `docs/agent-memory/infrastructure_plan.md`
