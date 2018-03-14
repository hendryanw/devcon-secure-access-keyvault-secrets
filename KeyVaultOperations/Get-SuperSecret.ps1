Param (
	[string] [Parameter(Mandatory = $true)] $ServicePrincipalId,
	[string] [Parameter(Mandatory = $true)] $TenantId
)

$ErrorActionPreference = "Stop";

# Install and Import AzureRM.KeyVault module
Install-Module AzureRM.KeyVault -Force
Import-Module AzureRM.KeyVault

# Get the certificate thumbprint
$certThumbprint = (Get-ChildItem cert:\LocalMachine\My\ | Where-Object {$_.Subject -match 'hendrydevcon' }).Thumbprint

# Login using the certificate.
Login-AzureRmAccount -ServicePrincipal `
  -CertificateThumbprint $certThumbprint `
  -ApplicationId $ServicePrincipalId `
  -TenantId $TenantId

# Get the secret value.
$secret = Get-AzureKeyVaultSecret `
	-VaultName devcon-kv `
	-Name super-secret `
	-Version 105323781e354fdbbeb60546fb4f9945

# Print the secret value.
Write-Host "I got your super secret: $($secret.SecretValueText)"