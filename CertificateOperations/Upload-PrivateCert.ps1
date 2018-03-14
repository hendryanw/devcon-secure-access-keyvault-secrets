Param (
	[string] [Parameter(Mandatory=$true)] $PrivateCertFilePath,
	[string] [Parameter(Mandatory=$true)] $VaultName,
	[string] [Parameter(Mandatory=$true)] $SecretName
)

$ErrorActionPreference = "Stop";

# Convert the private certificate file into base64 string representation.
$base64PrivateCert = [System.Convert]::ToBase64String((Get-Content $PrivateCertFilePath -Encoding Byte))

# Ask for the private certificate password.
$password = Read-Host -Prompt "Enter the Private Certificate password..." -AsSecureString

# Construct the Set-AzureKeyVaultSecret payload.
$jsonPayload = @"
{
    "data": "$base64PrivateCert",
    "dataType" :"pfx",
    "password": "$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)))"
}
"@

# Convert the payload into base64 string.
$base64JsonPayload = [System.Convert]::ToBase64String(([System.Text.Encoding]::UTF8.GetBytes($jsonPayload)))

# Create a Secure String from the json payload.
$secret = ConvertTo-SecureString -String $base64JsonPayload -AsPlainText -Force

# Execute the Set-AzureKeyVaultSecret cmdlet.
$result = Set-AzureKeyVaultSecret -VaultName $VaultName -Name $SecretName -SecretValue $secret

Write-Output $result