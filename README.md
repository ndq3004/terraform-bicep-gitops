# Azure Role Assignments for GitOps Project

## Required Azure Roles

This project uses GitHub Actions and ArgoCD for infrastructure automation. The following Azure roles are required for proper access and permissions:

### 1. **Service Principal Roles**

#### For GitHub Actions CI/CD Pipeline:
- **Contributor** - Full access to create and manage resources in the subscription
- **User Access Administrator** - To manage role assignments if needed

#### For ArgoCD Application:
- **Reader** - Read access to resources for monitoring and health checks
- **Azure Kubernetes Service (AKS) Cluster Admin** - If deploying to AKS clusters
- **Key Vault Secrets User** - To read secrets from Azure Key Vault (if applicable)

### 2. **Resource-Specific Roles**

- **Managed Identity Operator** - To manage managed identities
- **Virtual Machine Contributor** - If managing VMs
- **Network Contributor** - For networking resources
- **Storage Account Contributor** - For storage operations
- **Container Registry Contributor** - If using Azure Container Registry

### 3. **Recommended Minimal Permissions**

For production environments, use the principle of least privilege:

- **GitHub Actions**: Scoped to specific resource groups with **Contributor** role
- **ArgoCD**: Use **Reader** + **Key Vault Secrets User** + specific resource permissions

### 4. **Role Assignment Steps**

```bash
# Assign Contributor role to Service Principal for GitHub Actions
az role assignment create \
  --assignee <service-principal-object-id> \
  --role "Contributor" \
  --scope /subscriptions/<subscription-id>/resourceGroups/<resource-group>

# Assign Reader role to ArgoCD managed identity
az role assignment create \
  --assignee <argocd-managed-identity-id> \
  --role "Reader" \
  --scope /subscriptions/<subscription-id>
```

## Security Best Practices

- ✅ Use Managed Identities instead of Service Principals when possible
- ✅ Scope roles to specific resource groups, not entire subscriptions
- ✅ Regularly audit role assignments
- ✅ Use Azure Policy to enforce role assignments
- ✅ Enable Azure RBAC on AKS clusters for Kubernetes RBAC integration
