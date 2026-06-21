# Setup script for infra-iac repository
# Verifies and installs required tools: Azure CLI, Terraform, Bicep

param(
    [switch]$InstallMissing = $false
)

$ErrorActionPreference = "Stop"
$requiredTools = @{
    "az"        = "Azure CLI"
    "terraform" = "Terraform"
    "bicep"     = "Bicep CLI"
}

Write-Host "=== infra-iac Repository Setup ===" -ForegroundColor Cyan
Write-Host ""

$allOk = $true

foreach ($tool in $requiredTools.Keys) {
    $toolName = $requiredTools[$tool]
    Write-Host "Checking $toolName..." -NoNewline

    $installed = $null
    try {
        $installed = & $tool version 2>$null
    }
    catch {
        # Tool not found
    }

    if ($installed) {
        Write-Host ' ✓ INSTALLED' -ForegroundColor Green
        Write-Host "  Version: $($installed.Split([Environment]::NewLine)[0])"
    }
    else {
        Write-Host ' ✗ NOT FOUND' -ForegroundColor Red
        $allOk = $false
    }
}

if (-not $allOk) {
    Write-Host ''
    Write-Host '=== Missing Tools ===' -ForegroundColor Yellow

    if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
        Write-Host 'Azure CLI: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows'
    }
    if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
        Write-Host 'Terraform: https://www.terraform.io/downloads'
    }
    if (-not (Get-Command bicep -ErrorAction SilentlyContinue)) {
        Write-Host 'Bicep: Install via ''az bicep install'' (requires Azure CLI first)'
    }

    if (-not $InstallMissing) {
        Write-Host ''
        Write-Host 'Run with -InstallMissing to attempt auto-install (requires admin)' -ForegroundColor Yellow
        exit 1
    }
    else {
        Write-Host ''
        Write-Host '=== Attempting Auto-Install ===' -ForegroundColor Cyan
        
        # Azure CLI via winget (requires Windows Package Manager)
        if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
            Write-Host 'Installing Azure CLI...' -ForegroundColor Yellow
            winget install Microsoft.AzureCLI
        }

        # Terraform via winget
        if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
            Write-Host 'Installing Terraform...' -ForegroundColor Yellow
            winget install HashiCorp.Terraform
        }

        # Bicep via az
        if ((Get-Command az -ErrorAction SilentlyContinue) -and -not (Get-Command bicep -ErrorAction SilentlyContinue)) {
            Write-Host 'Installing Bicep...' -ForegroundColor Yellow
            az bicep install
        }
    }
}

Write-Host ''
Write-Host '=== Setup Complete ===' -ForegroundColor Green
Write-Host 'Ready to use infra-iac repository'
