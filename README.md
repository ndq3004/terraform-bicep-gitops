# infra-iac: GitHub Actions Setup Guide

This repository uses OIDC login from GitHub Actions to Azure for Terraform and Bicep deployments.

## 1. Required GitHub Secrets

### Repository-level secrets

Add these in GitHub:
Settings -> Secrets and variables -> Actions -> Repository secrets

- AZURE_TENANT_ID
- AZURE_SUBSCRIPTION_ID

### Environment-level secrets

Create GitHub Environments: dev, stg, prd

Add this secret in each environment:
- AZURE_CLIENT_ID

Recommended:
- dev uses a lower-privilege app registration/service principal
- stg/prd use separate app registrations/service principals

## 2. Required Azure Configuration (OIDC)

For each GitHub environment identity (dev/stg/prd):

1. Create an Entra ID App Registration.
2. Create a Service Principal for that app.
3. Add Federated Credential to the app with subject:
	 - repo:ndq3004/terraform-bicep-gitops:environment:dev
	 - repo:ndq3004/terraform-bicep-gitops:environment:stg
	 - repo:ndq3004/terraform-bicep-gitops:environment:prd
4. Assign RBAC roles at least privilege scope (resource group or subscription as needed).

Minimum role set depends on resources in your deployment. For broad infra creation, Contributor is commonly used at RG scope.

## 3. Terraform Remote State Setup

Backend files are expected per environment:

- terraform/envs/dev/backend-dev.hcl
- terraform/envs/stg/backend-stg.hcl
- terraform/envs/prd/backend-prd.hcl

These files should contain only non-secret values:

- resource_group_name
- storage_account_name
- container_name
- key

Do not store access keys, SAS tokens, or client secrets in backend hcl files.

## 4. GitHub Environment Protection Rules

In each environment settings page:

1. Add required reviewers for stg and prd.
2. Keep dev less restrictive for faster iteration.
3. Store AZURE_CLIENT_ID in each environment.

This works with workflow job setting:
- environment: ${{ github.event.inputs.environment }}

## 5. Workflow Behavior

Workflow file:
- .github/workflows/iac-plan-apply.yml

Current behavior:

- pull_request: local validation only (safe for forks)
	- Terraform fmt/check + init -backend=false + validate
	- Bicep build validation
- workflow_dispatch:
	- terraform plan/apply path
	- bicep what-if/apply path
	- apply jobs are gated by GitHub environment approvals

Terraform init in workflow uses environment backend file:
- terraform init -input=false -backend-config backend-${ENVIRONMENT}.hcl

## 6. First-Time Validation Commands

Run once per environment directory:

1. terraform init -backend-config backend-dev.hcl
2. terraform plan -var-file=terraform.tfvars

Equivalent for stg/prd by changing directory and backend file name.

## 7. Troubleshooting

- Error: Variables not allowed (backend block)
	- Cause: backend block cannot use var.*
	- Fix: keep backend block empty and pass -backend-config file at init

- Error: ResourceGroupNotFound during init
	- Cause: state resource group or storage account does not exist
	- Fix: create state RG, storage account, and container first

- Azure login fails in Actions
	- Verify AZURE_CLIENT_ID in the selected environment
	- Verify AZURE_TENANT_ID and AZURE_SUBSCRIPTION_ID repository secrets
	- Verify federated credential subject exactly matches repo and environment

