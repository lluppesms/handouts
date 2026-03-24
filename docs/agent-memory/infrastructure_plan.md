---
title: Infrastructure Plan for Lyle's Handouts Website
---

# Introduction

This document outlines the infrastructure plan for deploying Lyle's Handouts Website using Azure Bicep files. The plan is based on the requirements in the project readme and Azure/Microsoft best practices. It details the Azure resources, their configurations, dependencies, parameters, and outputs required to support a static React website that dynamically lists handouts from Azure Blob Storage.

## Resources

### 1. Azure Storage Account (Blob Storage)
- **Purpose:** Store handout/reference files for student access.
- **Type:** General-purpose v2 storage account (recommended for most scenarios).
- **Configuration:**
  - Enable Blob service.
  - Create a container (e.g., `handouts`) for storing files.
  - Configure public access or use SAS tokens for secure access (prefer least privilege).
  - Consider static website hosting feature if direct blob access is not desired.
- **Parameters:**
  - Storage account name (must be globally unique, 3-24 lowercase letters/numbers).
  - Location/region.
  - Access tier (Hot/Cold/Archive).
  - Container name.
  - Public access level (None/Blob/Container).
- **Outputs:**
  - Storage account name.
  - Blob service endpoint.
  - Container name.

### 2. Azure Static Web App
- **Purpose:** Host the React website as a globally distributed static site.
- **Configuration:**
  - Link to the source repository for CI/CD (GitHub or Azure DevOps).
  - Configure build settings for React/TypeScript.
  - Set environment variables for storage access (e.g., blob endpoint, SAS token if needed).
  - Enable custom domain and SSL if required.
- **Parameters:**
  - Static Web App name.
  - Location/region.
  - Repository URL and branch (for CI/CD integration).
  - Build output location (e.g., `build` or `dist`).
- **Outputs:**
  - Static Web App URL.
  - Default hostname.

### 3. Role Assignment (RBAC)
- **Purpose:** Grant the Static Web App access to the Storage Account (if not using public access).
- **Configuration:**
  - Assign `Storage Blob Data Reader` role to the Static Web App's managed identity at the storage account or container scope.
- **Parameters:**
  - Principal ID (Static Web App managed identity).
  - Scope (storage account or container resource ID).
  - Role definition ID (Storage Blob Data Reader).
- **Outputs:**
  - Role assignment resource ID.

## Implementation Plan

The infrastructure will be defined using Bicep files in the `infra/bicep` folder. The plan is as follows:

### Phase 1 — Storage Account and Container
**Objective:** Provision a secure, scalable storage account and container for handouts.
- Deploy a general-purpose v2 storage account.
- Create a blob container for handouts.
- Configure access (public or SAS-based, as required).

### Phase 2 — Static Web App
**Objective:** Deploy the React website as a static web app.
- Deploy Azure Static Web App resource.
- Configure build and deployment settings.
- Set environment variables for storage access.

### Phase 3 — Role Assignment
**Objective:** Securely connect the Static Web App to the Storage Account.
- Assign the `Storage Blob Data Reader` role to the Static Web App's managed identity.
- Scope the assignment to the storage account or container as appropriate.

## High-level Design

- All infrastructure is defined as code using Bicep modules, following Azure Verified Module (AVM) standards where available.
- Parameters are used for resource names, locations, and access settings to support reuse and flexibility.
- Outputs provide key resource identifiers and endpoints for use in application configuration and deployment pipelines.
- RBAC is used to grant least-privilege access between the Static Web App and Storage Account.
- The design supports both public and private access to handouts, with a preference for secure, token-based access.

## References

- [Azure Storage Account Documentation](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)
- [Azure Static Web Apps Documentation](https://learn.microsoft.com/en-us/azure/static-web-apps/overview)
- [Azure RBAC Role Assignments](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal)
- [dadabase.demo Reference Repo](https://github.com/lluppesms/dadabase.demo/)

---
This plan provides a clear, actionable roadmap for implementing the required Azure infrastructure using Bicep, ensuring security, scalability, and maintainability.