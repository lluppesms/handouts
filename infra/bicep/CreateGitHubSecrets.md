# Set up GitHub Secrets

The GitHub workflows in this project require several secrets and variables set at the repository or environment level.

---

## Azure Credentials

Set up Azure credentials for OIDC authentication. You will need a service principal with federated credentials configured for your GitHub repository.

See [Deploying with GitHub Actions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions) for more info.

### Environment-Level Secrets (Recommended)

Set these for each environment (e.g., dev, qa, prod):

```bash
gh auth login

gh secret set --env dev AZURE_TENANT_ID -b <GUID>
gh secret set --env dev CICD_CLIENT_ID -b <GUID>
gh secret set --env dev AZURE_SUBSCRIPTION_ID -b <yourAzureSubscriptionId>
```

### Repository-Level Secrets (Alternative)

If using a single environment:

```bash
gh secret set AZURE_TENANT_ID -b <GUID>
gh secret set CICD_CLIENT_ID -b <GUID>
gh secret set AZURE_SUBSCRIPTION_ID -b <yourAzureSubscriptionId>
```

---

## Bicep Configuration Variables

These variables configure the Azure resource names. Make sure `APP_NAME` is unique — it forms the basis for all resource names (some must be globally unique).

```bash
gh variable set APP_NAME -b 'lyles-handouts'
gh variable set RESOURCE_GROUP_PREFIX -b 'rg-handouts'
gh variable set RESOURCE_GROUP_LOCATION -b 'centralus'
gh variable set INSTANCE_NUMBER -b '1'
```

---

## Summary

| Name | Type | Scope | Description |
|------|------|-------|-------------|
| `AZURE_TENANT_ID` | Secret | Environment | Azure AD tenant ID |
| `CICD_CLIENT_ID` | Secret | Environment | Service principal client ID |
| `AZURE_SUBSCRIPTION_ID` | Secret | Environment | Target Azure subscription |
| `APP_NAME` | Variable | Repository | Application name prefix |
| `RESOURCE_GROUP_PREFIX` | Variable | Repository | Resource group naming prefix |
| `RESOURCE_GROUP_LOCATION` | Variable | Repository | Azure region (e.g., centralus) |
| `INSTANCE_NUMBER` | Variable | Repository | Deployment instance number |

---

## References

- [Deploying ARM Templates with GitHub Actions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions)
- [GitHub Secrets CLI](https://cli.github.com/manual/gh_secret_set)
- [Configure OIDC for GitHub Actions](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust)
