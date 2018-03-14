### Create a new self-signed certificate
### The certificate will be imported into cert:\LocalMachine\My
### The private key and the public certificate will be exported into specified location.
### (Optional) : Create new service principal using the exported certificate.

param (
    [Parameter(Mandatory=$true)]
    [String] $DnsName,

    [Parameter(Mandatory=$true)]
    [String] $PrivateCertFilePath,

    [Parameter(Mandatory=$true)]
    [String] $PublicCertFilePath
)

$ErrorActionPreference = "STOP"

# Prompt for private certificate password.
$password = Read-Host -Prompt "Enter the private certificate password..." -AsSecureString

# Create new self-signed cert
$cert = New-SelfSignedCertificate `
    -DnsName $DnsName 
    -CertStoreLocation "cert:\LocalMachine\My" `
    -KeySpec KeyExchange `
    -KeyExportPolicy Exportable `
    -NotBefore (Get-Date).AddDays(-1) `
    -NotAfter (Get-Date).AddYears(1)

# Print the thumbprint
Write-Host "Certificate thumbprint:" $cert.Thumbprint

# Export the private certificate.
Export-PfxCertificate -Cert $cert -FilePath $PrivateCertFilePath -Password $password

# Export the public certificate.
Export-Certificate -Cert $cert -FilePath $PublicCertFilePath

# Print the public certificate.
Write-Output $cert