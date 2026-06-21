param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("terraform", "bicep")]
    [string]$Platform,

    [Parameter(Mandatory = $true)]
    [ValidateSet("dev", "stg", "prd")]
    [string]$Environment
)

$ErrorActionPreference = "Stop"

Write-Host "Platform: $Platform"
Write-Host "Environment: $Environment"

if ($Platform -eq "terraform") {
    $tfPath = "terraform/envs/$Environment"
    if (-not (Test-Path $tfPath)) {
        throw "Terraform path not found: $tfPath"
    }

    Push-Location $tfPath
    try {
        terraform init
        terraform plan -out tfplan
        terraform apply -auto-approve tfplan
    }
    finally {
        Pop-Location
    }
}
else {
    $paramFile = "bicep/parameters/$Environment.parameters.json"
    if (-not (Test-Path $paramFile)) {
        throw "Bicep parameter file not found: $paramFile"
    }

    az deployment sub create `
      --name "infra-$Environment-$(Get-Date -Format yyyyMMddHHmmss)" `
      --location "westeurope" `
      --template-file "bicep/main.bicep" `
      --parameters "@$paramFile"
}

Write-Host "Deployment flow completed."
